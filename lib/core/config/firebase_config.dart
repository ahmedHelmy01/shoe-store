/// Firebase Configuration for ERP System
/// Firebase will be configured when needed
class FirebaseConfig {
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String storageBucket;

  const FirebaseConfig({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    required this.storageBucket,
  });

  factory FirebaseConfig.fromJson(Map<String, dynamic> json) => FirebaseConfig(
    apiKey: json['apiKey'] ?? '',
    appId: json['appId'] ?? '',
    messagingSenderId: json['messagingSenderId'] ?? '',
    projectId: json['projectId'] ?? '',
    storageBucket: json['storageBucket'] ?? '',
  );

  /// Check if Firebase is configured
  bool get isConfigured => apiKey.isNotEmpty && appId.isNotEmpty;
}

/// Firebase Initializer - Will be implemented when Firebase is added
/// Add firebase_core to pubspec.yaml when ready to use Firebase
class FirebaseInitializer {
  static FirebaseConfig? config;

  static void setConfig(FirebaseConfig firebaseConfig) {
    config = firebaseConfig;
  }

  /// Initialize Firebase - implement when firebase_core is added
  /// static Future<void> initializeFirebase() async {
  ///   await Firebase.initializeApp(
  ///     options: FirebaseOptions(
  ///       apiKey: config!.apiKey,
  ///       appId: config!.appId,
  ///       messagingSenderId: config!.messagingSenderId,
  ///       projectId: config!.projectId,
  ///       storageBucket: config!.storageBucket,
  ///     ),
  ///   );
  /// }
}
