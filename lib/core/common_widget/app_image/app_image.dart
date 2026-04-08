import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'image_renderer.dart';

class AppImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;

  AppImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ImageRenderer.rendererImage(
      imagePath: imagePath,
      height: height,
      width: width,
      fit: fit,
      color: color,
      placeHolderText: LocaleKeys.common.noImage.tr(context: context),
    );
  }
}
