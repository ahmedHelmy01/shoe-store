/// WebStore CMS Page Model
///
/// Represents an informational page (like "About Us") from the WebStore API.
library;

import 'package:erp/core/network/network_url.dart';

class CmsPageModel {
  final int id;
  final String title;
  final String titleAr;
  final String slug;
  final String content;
  final String contentAr;
  final String? image;
  final String? imageUrl;

  const CmsPageModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.slug,
    required this.content,
    required this.contentAr,
    this.image,
    this.imageUrl,
  });

  factory CmsPageModel.fromJson(Map<String, dynamic> json) {
    final imagePath = json['image'] as String?;
    final providedUrl = json['image_url'] as String?;
    return CmsPageModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      content: json['content'] as String? ?? '',
      contentAr: json['content_ar'] as String? ?? '',
      image: imagePath,
      imageUrl: (providedUrl != null && providedUrl.isNotEmpty)
          ? providedUrl
          : (imagePath != null ? NetworkUrl.fullUrl(imagePath) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'slug': slug,
      'content': content,
      'content_ar': contentAr,
      'image': image,
      'image_url': imageUrl,
    };
  }
}
