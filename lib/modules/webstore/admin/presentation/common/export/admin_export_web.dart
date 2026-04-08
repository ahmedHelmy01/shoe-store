// Web implementation
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class AdminExportImpl {
  static Future<void> downloadText({
    required String filename,
    required String content,
    required String mimeType,
  }) async {
    final bytes = content.codeUnits;
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final a = html.AnchorElement(href: url)
      ..download = filename
      ..style.display = 'none';
    html.document.body?.children.add(a);
    a.click();
    a.remove();

    html.Url.revokeObjectUrl(url);
  }

  static Future<void> downloadBytes({
    required String filename,
    required List<int> bytes,
    required String mimeType,
  }) async {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final a = html.AnchorElement(href: url)
      ..download = filename
      ..style.display = 'none';
    html.document.body?.children.add(a);
    a.click();
    a.remove();

    html.Url.revokeObjectUrl(url);
  }
}

