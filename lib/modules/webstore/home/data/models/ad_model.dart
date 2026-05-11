import 'package:erp/core/network/network_service.dart';

/// WebStore Ad Model
///
/// Represents an advertisement banner from the WebStore API.
class AdModel {
  final int id;
  final String title;
  final String titleAr;
  final String? image;
  final int position;

  const AdModel({
    required this.id,
    required this.title,
    required this.titleAr,
    this.image,
    required this.position,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    String? imagePath = json['image'] as String?;
    
    // Ensure full URL for images with the correct /storage/ prefix
    if (imagePath != null && imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      // Fix potential double uploads/ prefix and ensure storage/ exists
      final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
      imagePath = 'https://moon-erp.elbaset.com/storage/$cleanPath';
    }

    return AdModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      image: imagePath,
      position: json['position'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'image': image,
      'position': position,
    };
  }
}
