import 'package:http/http.dart' as http;

/// A custom MultipartRequest that tracks upload progress.
class ProgressMultipartRequest extends http.MultipartRequest {
  final void Function(double)? onProgress;

  ProgressMultipartRequest(super.method, super.url, {this.onProgress});

  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = contentLength;
    int bytesSent = 0;

    return http.ByteStream(
      byteStream.map((chunk) {
        bytesSent += chunk.length;
        if (total > 0) {
          onProgress!(bytesSent / total);
        }
        return chunk;
      }),
    );
  }
}
