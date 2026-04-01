import 'package:flutter/material.dart';

typedef ScreenBuilder = Widget Function(BuildContext);

class ScreenModule {
  final String path;
  final ScreenBuilder builder;

  const ScreenModule({
    required this.path,
    required this.builder,
  });
}
