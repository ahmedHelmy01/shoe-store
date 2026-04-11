import 'admin_export_impl.dart';

class AdminExport {
  static Future<void> downloadText({
    required String filename,
    required String content,
    String mimeType = 'text/plain;charset=utf-8',
  }) {
    return AdminExportImpl.downloadText(
      filename: filename,
      content: content,
      mimeType: mimeType,
    );
  }

  static Future<void> downloadBytes({
    required String filename,
    required List<int> bytes,
    String mimeType = 'application/octet-stream',
  }) {
    return AdminExportImpl.downloadBytes(
      filename: filename,
      bytes: bytes,
      mimeType: mimeType,
    );
  }
}

