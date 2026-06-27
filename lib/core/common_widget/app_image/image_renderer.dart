import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:erp/core/common_widget/app_loader/app_loader.dart';
import 'package:erp/core/extension/image_type_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Class for loading images based on their type
class ImageRenderer {
  static Widget rendererImage({
    required String imagePath,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    Color? color,
    int? memCacheWidth,
    int? memCacheHeight,
    String? placeHolderImage,
    String? placeHolderText,
  }) {
    // If imagePath is empty, show placeholder immediately
    if (imagePath.isEmpty) {
      return _buildPlaceholder(height, width, fit);
    }

    // Clean the image path from any double slashes if they exist
    String cleanPath = imagePath.replaceAll('//', '/').replaceFirst('https:/', 'https://');
    switch (cleanPath.imageType) {
      case ImageType.network:
        if (kIsWeb) {
          return Image.network(
            cleanPath,
            height: height,
            width: width,
            fit: fit,
            color: color,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width, fit),
          );
        }
        return CachedNetworkImage(
          imageUrl: cleanPath,
          height: height,
          width: width,
          fit: fit,
          color: color,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          placeholder: (context, url) => Center(
            child: SizedBox(height: 20, width: 20, child: AppLoader(size: 20)),
          ),
          errorWidget: (context, url, error) => _buildPlaceholder(height, width, fit),
        );
      case ImageType.file:
        return Image.file(
          File(cleanPath),
          height: height,
          width: width,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width, fit),
        );
      case ImageType.svg:
        return SvgPicture.asset(
          cleanPath,
          height: height,
          width: width,
          fit: fit,
        );

      case ImageType.png:
      case ImageType.unknown:
        return Image.asset(
          cleanPath,
          height: height,
          width: width,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(height, width, fit),
        );
    }
  }

  static Widget _buildPlaceholder(
    double? height,
    double? width,
    BoxFit fit,
  ) {
    return Container(
      color: Colors.grey.withValues(alpha: 0.05),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey.withValues(alpha: 0.3),
          size: (height != null && height < 50) ? 18 : 24,
        ),
      ),
    );
  }
}
