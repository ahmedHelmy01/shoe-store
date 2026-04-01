import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'app_config.dart';
import 'app_flavor.dart';

class AppConfigManager {
  static late AppConfig _instance;

  static void init(AppConfig config) {
    _instance = config;
  }

  static AppConfig get instance => _instance;

  static Future<void> loadFromFile(String path, AppFlavor flavor) async {
    try {
      final jsonStr = await rootBundle.loadString(path);
      final data = json.decode(jsonStr);
      init(AppConfig.fromJson(data, flavor));
    } catch (e) {
      rethrow;
    }
  }
}
