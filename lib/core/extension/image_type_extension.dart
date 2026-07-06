import 'package:flutter/foundation.dart' show kIsWeb;

enum ImageType { svg, png, network, file, unknown }

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (isEmpty) {
      return ImageType.unknown;
    }
    if (startsWith('http') || startsWith('https') || startsWith('blob:')) {
      return ImageType.network;
    }
    if (endsWith('.svg')) {
      return ImageType.svg;
    }
    if (startsWith('file://')) {
      return ImageType.file;
    }
    // Detect local file system paths from image_picker
    if (!kIsWeb && (startsWith('/') ||
        (length > 2 && this[1] == ':' && (this[2] == '/' || this[2] == '\\')))) {
      return ImageType.file;
    }
    if (endsWith('.png') || endsWith('.jpg') || endsWith('.jpeg') || endsWith('.webp')) {
      return ImageType.png;
    }
    return ImageType.unknown;
  }


}
