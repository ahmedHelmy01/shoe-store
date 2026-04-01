import 'package:erp/core/localization/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'image_renderer.dart';

class AppImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;
  final Widget content;

  AppImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.cover,
  }) : content = ImageRenderer.rendererImage(
         imagePath: imagePath,
         height: height,
         width: width,
         fit: fit,
         color: color,
         placeHolderText: LocaleKeys.noImage.tr(),
       );

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
