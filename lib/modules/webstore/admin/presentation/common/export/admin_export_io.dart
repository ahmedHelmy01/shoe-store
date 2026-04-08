import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AdminExportImpl {
  static Future<void> downloadText({
    required String filename,
    required String content,
    required String mimeType,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);
  }

  static Future<void> downloadBytes({
    required String filename,
    required List<int> bytes,
    required String mimeType,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
  }
}

