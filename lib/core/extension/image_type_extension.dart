enum ImageType { svg, png, network, file, unknown }

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (isEmpty) {
      return ImageType.unknown;
    }
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    }
    if (endsWith('.svg')) {
      return ImageType.svg;
    }
    if (startsWith('file://')) {
      return ImageType.file;
    }
    if (endsWith('.png') || endsWith('.jpg') || endsWith('.jpeg')) {
      return ImageType.png;
    }
    // If the type is unrecognized, return unknown
    return ImageType.unknown;
  }
}
