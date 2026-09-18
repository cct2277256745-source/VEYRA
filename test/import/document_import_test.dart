import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veyra/features/import/document_import_service.dart';
import 'package:veyra/features/import/extractors/pdf_extractor.dart';
import 'package:veyra/features/import/extractors/txt_extractor.dart';
import 'package:veyra/features/import/extractors/docx_extractor.dart';

/// Slice 2.3：文件导入。fixtures 全部程序化构造，不依赖仓库内样例文件。
void main() {
  List<int> docxBytes(String bodyXml) {
    final archive = Archive();
    final xml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>$bodyXml</w:body>
</w:document>''';
    final bytes = utf8.encode(xml);
    archive.addFile(
        ArchiveFile('word/document.xml', bytes.length, bytes));
    return ZipEncoder().encode(archive);
  }

  List<int> pdfBytes({required String streamBody, bool compress = false}) {
    final body = compress
        ? ZLibCodec(raw: true).encoder.convert(utf8.encode(streamBody))
        : utf8.encode(streamBody);
    final buffer = StringBuffer();
    buffer.writeln('%PDF-1.4');
    buffer.writeln('1 0 obj');
    buffer.writeln('<< /Length ${body.length} >>');
    buffer.write('stream\n');
    buffer.write(latin1.decode(body, allowInvalid: true));
    buffer.writeln('');
    buffer.writeln('endstream');
    buffer.writeln('endobj');
    buffer.writeln('trailer');
    buffer.writeln('<< /Root 1 0 R >>');
    buffer.writeln('%%EOF');
    return latin1.encode(buffer.toString());
  }

  group('TXT / Markdown', () {
    test('UTF-8 中文计划正常提取', () async {
      final text = await TextLikeExtractor()
          .extractText(utf8.encode('# 雅思计划\n\n第一周：听力'), 'plan.md');
      expect(text, contains('雅思计划'));
      expect(text, contains('第一周：听力'));
    });

    test('非 UTF-8 内容给出明确失败', () async {
      await expectLater(
        TextLikeExtractor().extractText([0xff, 0xfe, 0x00, 0x41], 'bad.txt'),
        throwsA(isA<ImportException>()),
      );
    });
  });

  group('DOCX', () {
    test('段落文本按 w:t 提取并换行', () async {
      final bytes = docxBytes(
          '<w:p><w:r><w:t>第一周：听力</w:t></w:r></w:p><w:p><w:r><w:t>第二周：阅读</w:t></w:r></w:p>');
      final text = await DocxExtractor().extractText(bytes, 'plan.docx');
      expect(text, contains('第一周：听力'));
      expect(text, contains('第二周：阅读'));
    });

    test('损坏的 ZIP 给出明确失败', () async {
      await expectLater(
        DocxExtractor().extractText([1, 2, 3, 4], 'broken.docx'),
        throwsA(isA<ImportException>()),
      );
    });
  });

  group('PDF', () {
    test('未压缩文本流：Tj 字面量', () async {
      final bytes = pdfBytes(streamBody: 'BT /F1 12 Tf (Hello VEYRA) Tj ET');
      final text = await PdfExtractor().extractText(bytes, 'plan.pdf');
      expect(text, contains('Hello VEYRA'));
    });

    test('Flate 压缩文本流', () async {
      final bytes = pdfBytes(
          streamBody: 'BT /F1 12 Tf (Plan week one) Tj ET', compress: true);
      final text = await PdfExtractor().extractText(bytes, 'plan.pdf');
      expect(text, contains('Plan week one'));
    });

    test('UTF-16BE 十六进制字符串（中文）', () async {
      final jian = '健'.codeUnits.map((c) => c.toRadixString(16).padLeft(4, '0')).join();
      final shen = '身'.codeUnits.map((c) => c.toRadixString(16).padLeft(4, '0')).join();
      final hex = 'FEFF$jian$shen';
      final bytes =
          pdfBytes(streamBody: 'BT /F1 12 Tf <$hex> Tj ET');
      final text = await PdfExtractor().extractText(bytes, 'plan.pdf');
      expect(text, contains('健身'));
    });

    test('加密 PDF 明确提示', () async {
      final bytes = latin1.encode(
          '%PDF-1.4\ntrailer\n<< /Encrypt 9 0 R /Root 1 0 R >>\n%%EOF');
      await expectLater(
        PdfExtractor().extractText(bytes, 'locked.pdf'),
        throwsA(predicate<ImportException>(
            (e) => e.reason.contains('加密'))),
      );
    });

    test('无文字 PDF（扫描件场景）明确失败', () async {
      final bytes = pdfBytes(streamBody: 'q 1 0 0 1 0 0 cm Q');
      await expectLater(
        PdfExtractor().extractText(bytes, 'scan.pdf'),
        throwsA(predicate<ImportException>(
            (e) => e.reason.contains('没有从这份 PDF'))),
      );
    });

    test('非 PDF 文件头明确失败', () async {
      await expectLater(
        PdfExtractor().extractText(utf8.encode('hello'), 'fake.pdf'),
        throwsA(isA<ImportException>()),
      );
    });
  });

  group('DocumentImportService', () {
    test('按扩展名分发并保存 SourceDocument', () async {
      final saved = <ExtractedDocument>[];
      final service = DocumentImportService(
        saveSourceDocument: (extracted) async {
          saved.add(extracted);
          return 42;
        },
      );
      final extracted = await service
          .importFromBytes(utf8.encode('8 周雅思计划'), 'plan.txt');
      expect(extracted.fileKind, 'txt');
      expect(saved.single.fileName, 'plan.txt');
    });

    test('空文件失败', () async {
      final service = DocumentImportService(saveSourceDocument: (_) async => 1);
      await expectLater(
        service.importFromBytes([], 'empty.txt'),
        throwsA(isA<ImportException>()),
      );
    });

    test('不支持的类型失败', () async {
      final service = DocumentImportService(saveSourceDocument: (_) async => 1);
      await expectLater(
        service.importFromBytes(utf8.encode('x'), 'table.xlsx'),
        throwsA(predicate<ImportException>((e) => e.reason.contains('xlsx'))),
      );
    });

    test('磁盘文件导入', () async {
      final dir = await Directory.systemTemp.createTemp('veyra_import');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/plan.txt');
      await file.writeAsString('12 周健身计划', flush: true);
      final service = DocumentImportService(saveSourceDocument: (_) async => 1);
      final extracted = await service.importFromFile(file);
      expect(extracted.text, contains('12 周健身计划'));
    });
  });
}
