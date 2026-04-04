/// WebStore Auth Response Model
///
/// Wraps the full API response for login/register endpoints.
/// Response shape:
/// ```json
/// {
///   "data": { "id": 1, "name": "...", "email": "...", "mobile": "..." },
///   "token": "eyJ..."
/// }
/// ```
library;

import 'webstore_user_model.dart';

class WebStoreAuthResponse {
  final WebStoreUser user;
  final String token;

  const WebStoreAuthResponse({
    required this.user,
    required this.token,
  });

  factory WebStoreAuthResponse.fromJson(Map<String, dynamic> json) {
    return WebStoreAuthResponse(
      user: WebStoreUser.fromJson(json['data'] as Map<String, dynamic>),
      token: json['token'] as String? ?? '',
    );
  }
}
