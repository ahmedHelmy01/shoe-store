import 'package:flutter/material.dart';

Alignment textAlignment(BuildContext context) {
  return Directionality.of(context) == TextDirection.rtl
      ? Alignment.centerRight
      : Alignment.centerLeft;
}