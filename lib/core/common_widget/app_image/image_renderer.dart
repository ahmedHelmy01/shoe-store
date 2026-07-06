import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:erp/core/extension/image_type_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';

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

    // Clean double slashes in path (but not in protocol scheme)
    String cleanPath = imagePath;
    final protocolIndex = cleanPath.indexOf('://');
    if (protocolIndex != -1) {
      final protocol = cleanPath.substring(0, protocolIndex + 3);
      final rest = cleanPath.substring(protocolIndex + 3);
      String cleanedRest = rest;
      while (cleanedRest.contains('//')) {
        cleanedRest = cleanedRest.replaceAll('//', '/');
      }
      cleanPath = '$protocol$cleanedRest';
    } else {
      while (cleanPath.contains('//')) {
        cleanPath = cleanPath.replaceAll('//', '/');
      }
    }
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
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: width,
                height: height,
                child: AppShimmer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
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
          httpHeaders: const {
            'User-Agent': 'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36',
            'Accept': 'image/avif,image/webp,image/apng,image/png,image/jpg,*/*;q=0.8',
            'Connection': 'close',
          },
          placeholder: (context, url) => SizedBox(
            width: width,
            height: height,
            child: AppShimmer(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => _buildPlaceholder(height, width, fit),
        );
      case ImageType.file:
        final filePath = cleanPath.startsWith('file://')
            ? cleanPath.replaceFirst('file://', '')
            : cleanPath;
        return Image.file(
          File(filePath),
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
      margin: EdgeInsets.all(5),
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
