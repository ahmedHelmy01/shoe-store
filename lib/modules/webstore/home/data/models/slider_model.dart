import 'package:erp/core/network/network_url.dart';

class SliderModel {
  final int id;
  final String? title;
  final String? titleAr;
  final String image;
  final String? linkUrl;

  const SliderModel({
    required this.id,
    this.title,
    this.titleAr,
    required this.image,
    this.linkUrl,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    final imagePath = json['image'] as String? ?? '';
    return SliderModel(
      id: json['id'] as int,
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      image: NetworkUrl.imageUrl(imagePath),
      linkUrl: json['title_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'image': image,
      'title_url': linkUrl,
    };
  }
}
