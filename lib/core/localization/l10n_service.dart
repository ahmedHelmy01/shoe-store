import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class L10nService {
  static final L10nService _instance = L10nService._internal();
  factory L10nService() => _instance;
  L10nService._internal();

  /// Change language
  Future<void> changeLocale(BuildContext context, String languageCode) async {
    await context.setLocale(Locale(languageCode));
  }

  /// Current locale
  Locale currentLocale(BuildContext context) => context.locale;

  /// Is RTL
  bool isRtl(BuildContext context) => context.locale.languageCode == 'ar';
}
