/// Slice 2.3：文档导入抽象（PRD §18）。
///
/// 流程：文件 → 类型识别 → 文本提取 →（后续 Slice 2.5 再交给 AI 解析）。
/// 允许胡编内容是红线：提取失败必须给出明确原因（PRD §22）。
library;

import 'dart:io';

import 'extractors/docx_extractor.dart';
import 'extractors/pdf_extractor.dart';
import 'extractors/txt_extractor.dart';

/// 提取结果。
class ExtractedDocument {
  const ExtractedDocument({
    required this.fileName,
    required this.fileKind,
    required this.text,
    this.filePath,
  });

  final String fileName;
  final String fileKind;
  final String? filePath;
  final String text;

  bool get isEmpty => text.trim().isEmpty;
}

/// 导入失败，reason 面向用户展示（语言温和、明确）。
class ImportException implements Exception {
  ImportException(this.reason);

  final String reason;

  @override
  String toString() => reason;
}

/// 单一文件类型的提取器接口。
abstract class DocumentExtractor {
  /// 是否处理该扩展名（小写、不含点）。
  bool canHandle(String extension);

  Future<String> extractText(List<int> bytes, String fileName);
}

/// 按扩展名分发的导入服务。
class DocumentImportService {
  DocumentImportService({required this.saveSourceDocument, List<DocumentExtractor>? extractors})
      : extractors = extractors ?? defaultExtractors();

  /// 提取成功后的持久化回调（由仓储层注入）。
  final Future<int> Function(ExtractedDocument extracted) saveSourceDocument;

  final List<DocumentExtractor> extractors;

  static List<DocumentExtractor> defaultExtractors() => [
        TextLikeExtractor(),
        DocxExtractor(),
        PdfExtractor(),
      ];

  /// 从本地文件导入。任何失败都抛 ImportException（reason 可直接展示）。
  Future<ExtractedDocument> importFromFile(File file) async {
    if (!file.existsSync()) {
      throw ImportException('文件不存在，请确认文件位置。');
    }
    final fileName = file.uri.pathSegments.last;
    return importFromBytes(await file.readAsBytes(), fileName);
  }

  Future<ExtractedDocument> importFromBytes(
      List<int> bytes, String fileName) async {
    final dot = fileName.lastIndexOf('.');
    final ext = dot < 0 ? '' : fileName.substring(dot + 1).toLowerCase();
    if (bytes.isEmpty) {
      throw ImportException('文件是空的，没有可提取的内容。');
    }
    final extractor = extractors.where((e) => e.canHandle(ext)).toList();
    if (extractor.isEmpty) {
      throw ImportException('暂时不支持这个文件类型（.$ext）。可以先转成 TXT、Markdown、PDF 或 DOCX。');
    }
    try {
      final text = await extractor.first.extractText(bytes, fileName);
      if (text.trim().isEmpty) {
        throw ImportException('没有从文件里提取到文字。如果它是一份扫描件，目前还无法识别。');
      }
      final extracted = ExtractedDocument(
        fileName: fileName,
        fileKind: ext,
        filePath: null,
        text: text,
      );
      await saveSourceDocument(extracted);
      return extracted;
    } on ImportException {
      rethrow;
    } catch (e) {
      throw ImportException('读取文件时出现问题（$e），已安全停止，未产生任何数据。');
    }
  }
}
