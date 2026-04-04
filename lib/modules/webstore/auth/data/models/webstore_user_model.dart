/// WebStore User Model
///
/// Represents a customer user from the WebStore auth API response.
library;

class WebStoreUser {
  final int id;
  final String name;
  final String? email;
  final String? mobile;

  const WebStoreUser({
    required this.id,
    required this.name,
    this.email,
    this.mobile,
  });

  factory WebStoreUser.fromJson(Map<String, dynamic> json) {
    return WebStoreUser(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }
}
