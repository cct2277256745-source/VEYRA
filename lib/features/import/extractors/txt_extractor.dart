/// TXT / Markdown 提取器：按 UTF-8 严格解码。
/// Markdown 不做结构转换（结构化解析属于 Slice 2.5 的 AI 解析）。
library;

import 'dart:convert';

import '../document_import_service.dart';

class TextLikeExtractor implements DocumentExtractor {
  static const _extensions = {'txt', 'md', 'markdown'};

  @override
  bool canHandle(String extension) => _extensions.contains(extension);

  @override
  Future<String> extractText(List<int> bytes, String fileName) async {
    try {
      return utf8.decode(bytes, allowMalformed: false);
    } on FormatException {
      throw ImportException('这个文件不是有效的 UTF-8 文本，可能是其他编码或已损坏。');
    }
  }
}
