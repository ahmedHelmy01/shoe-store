/// WebStore User Model
///
/// Represents a customer user from the WebStore auth API response.
library;

class WebStoreUser {
  final int id;
  final String name;
  final String? email;
  final String? mobile;
  final int? branchId;
  final int? governorateId;
  final int? cityId;
  final String? address;
  final int points;

  const WebStoreUser({
    required this.id,
    required this.name,
    this.email,
    this.mobile,
    this.branchId,
    this.governorateId,
    this.cityId,
    this.address,
    this.points = 0,
  });

  factory WebStoreUser.fromJson(Map<String, dynamic> json) {
    return WebStoreUser(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      branchId: json['branch_id'] as int?,
      governorateId: json['governorate_id'] as int?,
      cityId: json['city_id'] as int?,
      address: json['address'] as String?,
      points: json['points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'branch_id': branchId,
      'governorate_id': governorateId,
      'city_id': cityId,
      'address': address,
      'points': points,
    };
  }
}
