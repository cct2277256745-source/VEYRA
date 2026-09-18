/// DOCX 提取器：DOCX 是 ZIP 容器，读取 word/document.xml 收集 w:t 文本，
/// w:p 段落之间换行。纯 Dart 实现（archive + xml），无平台依赖。
library;

import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import '../document_import_service.dart';

class DocxExtractor implements DocumentExtractor {
  @override
  bool canHandle(String extension) => extension == 'docx';

  @override
  Future<String> extractText(List<int> bytes, String fileName) async {
    final Archive? zip;
    try {
      zip = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      throw ImportException('这个 DOCX 文件已损坏，无法读取。');
    }
    final entry = zip.findFile('word/document.xml');
    if (entry == null) {
      throw ImportException('这不是有效的 Word 文档（缺少正文部分）。');
    }
    final String xmlContent;
    try {
      xmlContent = utf8.decode(entry.content as List<int>, allowMalformed: false);
    } on FormatException {
      throw ImportException('这个 DOCX 文件的正文无法解码。');
    }
    final buffer = StringBuffer();
    try {
      final doc = XmlDocument.parse(xmlContent);
      final paragraphs = doc.descendants
          .whereType<XmlElement>()
          .where((e) => e.name.local == 'p');
      for (final paragraph in paragraphs) {
        final line = paragraph.descendants
            .whereType<XmlText>()
            .map((node) => node.value)
            .join();
        buffer.writeln(line);
      }
    } on XmlException {
      throw ImportException('这个 DOCX 文件的正文格式异常，无法解析。');
    }
    return buffer.toString();
  }
}
