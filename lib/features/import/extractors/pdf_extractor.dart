/// 轻量 PDF 文本提取器（纯 Dart，覆盖 PRD §18 的“可复制文字 PDF”范围）。
///
/// 策略：扫描 stream/endstream 内容块 → 优先 raw inflate 解压 →
/// 提取 Tj / TJ / ' / " 文本算子中的字面量与十六进制字符串。
/// 不做字体 CMap 完整解析；提取不到文字时给出明确失败（允许后续接入更强方案）。
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import '../document_import_service.dart';

class PdfExtractor implements DocumentExtractor {
  @override
  bool canHandle(String extension) => extension == 'pdf';

  @override
  Future<String> extractText(List<int> bytes, String fileName) async {
    final head =
        latin1.decode(bytes.sublist(0, math.min(8, bytes.length)), allowInvalid: true);
    if (!head.startsWith('%PDF-')) {
      throw ImportException('这个文件看起来不是有效的 PDF。');
    }
    final latin = latin1.decode(bytes, allowInvalid: true);
    if (latin.contains('/Encrypt')) {
      throw ImportException('这个 PDF 加密了，暂时无法读取。请先解除密码保护再导入。');
    }
    final chunks = <String>[];
    var index = 0;
    while (true) {
      final streamStart = latin.indexOf('stream', index);
      if (streamStart < 0) break;
      var dataStart = streamStart + 'stream'.length;
      if (latin[dataStart] == '\r') dataStart += 1;
      if (latin[dataStart] == '\n') dataStart += 1;
      final streamEnd = latin.indexOf('endstream', dataStart);
      if (streamEnd < 0) break;
      final raw = Uint8List.sublistView(
          Uint8List.fromList(bytes), dataStart, streamEnd);
      final inflated = _inflateOrNull(raw) ?? raw;
      final content = latin1.decode(inflated, allowInvalid: true);
      if (content.contains('BT')) {
        chunks.add(_extractTextOperators(content));
      }
      index = streamEnd + 'endstream'.length;
    }
    final text = chunks.join('\n').trim();
    if (text.isEmpty) {
      throw ImportException('没有从这份 PDF 里提取到文字。如果它是一份扫描件，目前还无法识别。');
    }
    return text;
  }

  List<int>? _inflateOrNull(Uint8List raw) {
    for (final rawDeflate in [true, false]) {
      try {
        return ZLibCodec(raw: rawDeflate).decoder.convert(raw);
      } catch (_) {
        // 尝试下一种方式或放弃。
      }
    }
    return null;
  }

  /// 从内容流中抽取文本算子的参数。
  String _extractTextOperators(String content) {
    final buffer = StringBuffer();
    var i = 0;
    while (i < content.length) {
      final ch = content[i];
      if (ch == '(') {
        final literal = _readLiteral(content, i);
        buffer.write(literal.text);
        i = literal.endIndex;
      } else if (ch == '<' && i + 1 < content.length && content[i + 1] != '<') {
        final hex = _readHex(content, i);
        buffer.write(hex.text);
        i = hex.endIndex;
      } else if (ch == 'T' &&
          i + 1 < content.length &&
          (content[i + 1] == '*' || content[i + 1] == 'd' || content[i + 1] == 'D' || content[i + 1] == 'J')) {
        buffer.writeln();
        i += 2;
      } else {
        i += 1;
      }
    }
    return buffer.toString();
  }

  _Token _readLiteral(String s, int start) {
    final buffer = StringBuffer();
    var i = start + 1;
    var depth = 1;
    while (i < s.length && depth > 0) {
      final ch = s[i];
      if (ch == r'\') {
        i += 1;
        if (i >= s.length) break;
        final esc = s[i];
        switch (esc) {
          case 'n':
            buffer.write('\n');
          case 'r':
            buffer.write('\r');
          case 't':
            buffer.write('\t');
          case '(':
          case ')':
          case r'\':
            buffer.write(esc);
          default:
            // 八进制 \ddd
            if (RegExp('[0-7]').hasMatch(esc)) {
              var oct = esc;
              while (oct.length < 3 &&
                  i + 1 < s.length &&
                  RegExp('[0-7]').hasMatch(s[i + 1])) {
                i += 1;
                oct += s[i];
              }
              buffer.writeCharCode(int.parse(oct, radix: 8));
            } else {
              buffer.write(esc);
            }
        }
        i += 1;
      } else if (ch == '(') {
        depth += 1;
        buffer.write(ch);
        i += 1;
      } else if (ch == ')') {
        depth -= 1;
        if (depth > 0) buffer.write(ch);
        i += 1;
      } else {
        buffer.write(ch);
        i += 1;
      }
    }
    return _Token(buffer.toString(), i);
  }

  _Token _readHex(String s, int start) {
    final close = s.indexOf('>', start);
    if (close < 0) return _Token('', s.length);
    var hex = s.substring(start + 1, close).replaceAll(RegExp(r'\s'), '');
    if (hex.length.isOdd) hex += '0';
    try {
      if (hex.toUpperCase().startsWith('FEFF')) {
        // UTF-16BE 文本
        final units = <int>[];
        for (var i = 0; i + 3 < hex.length + 1 && i + 4 <= hex.length; i += 4) {
          units.add(int.parse(hex.substring(i, i + 4), radix: 16));
        }
        return _Token(String.fromCharCodes(units), close + 1);
      }
      final bytes = <int>[];
      for (var i = 0; i + 1 < hex.length + 1 && i + 2 <= hex.length; i += 2) {
        bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
      }
      return _Token(utf8.decode(bytes, allowMalformed: true), close + 1);
    } on FormatException {
      return _Token('', close + 1);
    }
  }
}

class _Token {
  const _Token(this.text, this.endIndex);

  final String text;
  final int endIndex;
}
