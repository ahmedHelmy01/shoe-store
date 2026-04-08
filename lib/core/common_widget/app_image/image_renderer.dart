import 'dart:io';
import 'package:erp/core/common_widget/app_loader/app_loader.dart';
import 'package:erp/core/extension/image_type_extension.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
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
    String? placeHolderImage,
    String? placeHolderText,
  }) {
    final String fallbackText = placeHolderText ?? LocaleKeys.common.noImage;

    if (imagePath.isEmpty) {
      return _buildPlaceholder(fallbackText, height, width, fit);
    }

    switch (imagePath.imageType) {
      case ImageType.network:
        return CachedNetworkImage(
          imageUrl: imagePath,
          height: height,
          width: width,
          fit: fit,
          color: color,
          placeholder: (context, url) => Center(
            child: SizedBox(height: 20, width: 20, child: AppLoader(size: 20)),
          ),
          errorWidget: (context, url, error) => _buildPlaceholder(
            (fallbackText).tr(context: context),
            height,
            width,
            fit,
          ),
        );
      case ImageType.file:
        return Image.file(
          File(imagePath),
          height: height,
          width: width,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(
              (fallbackText).tr(context: context),
              height,
              width,
              fit,
            );
          },
        );
      case ImageType.svg:
        return SvgPicture.asset(
          imagePath,
          height: height,
          width: width,
          fit: fit,
        );

      case ImageType.png:
      case ImageType.unknown:
        return Image.asset(
          imagePath,
          height: height,
          width: width,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(
              (fallbackText).tr(context: context),
              height,
              width,
              fit,
            );
          },
        );
    }
  }

  static Widget _buildPlaceholder(
    String text,
    double? height,
    double? width,
    BoxFit fit,
  ) {
    final bool isSmall =
        (height != null && height <= 40) || (width != null && width <= 40);

    return Center(
      child: isSmall
          ? const Icon(
              Icons.image_not_supported_outlined,
              size: 18,
              color: Colors.grey,
            )
          : SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
