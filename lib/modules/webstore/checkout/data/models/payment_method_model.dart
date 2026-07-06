import 'package:erp/core/network/network_url.dart';

class PaymentMethodModel {
  final int id;
  final String name;
  final String? code;
  final String? image;
  final bool isActive;

  PaymentMethodModel({
    required this.id,
    required this.name,
    this.code,
    this.image,
    this.isActive = true,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    final imagePath = json['image']?.toString();
    return PaymentMethodModel(
      id: json['id'] as int,
      name: json['name_ar'] ?? json['name'] ?? json['title'] ?? '',
      code: json['code']?.toString(),
      image: imagePath != null ? NetworkUrl.imageUrl(imagePath) : null,
      isActive: json['is_active'] == 1 || json['is_active'] == true || json['is_active'] == null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (code != null) 'code': code,
      if (image != null) 'image': image,
      'is_active': isActive,
    };
  }
}
