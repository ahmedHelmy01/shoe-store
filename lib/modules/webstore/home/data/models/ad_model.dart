import 'package:erp/core/network/network_url.dart';

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
    final imagePath = json['image'] as String?;
    return AdModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      image: imagePath != null ? NetworkUrl.imageUrl(imagePath) : null,
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
