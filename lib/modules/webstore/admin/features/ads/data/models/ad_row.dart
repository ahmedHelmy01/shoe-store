import 'package:erp/core/network/network_url.dart';

class AdRow {
  final int id;
  final String title;
  final String? titleAr;
  final String? content;
  final String? contentAr;
  final String? image;
  final String? imageUrl;
  final String? location;
  final String? linkUrl;
  final bool isActive;
  final int? companyId;
  final int? productCategoryId;
  final String? createdAt;
  final String? updatedAt;

  const AdRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.content,
    this.contentAr,
    this.image,
    this.imageUrl,
    this.location,
    this.linkUrl,
    required this.isActive,
    this.companyId,
    this.productCategoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory AdRow.fromJson(Map<String, dynamic> json) {
    final imagePath = json['image'] as String?;
    final providedUrl = json['image_url'] as String?;

    return AdRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      content: json['content'] as String?,
      contentAr: json['content_ar'] as String?,
      image: imagePath,
      imageUrl: providedUrl ?? (imagePath != null ? NetworkUrl.fullUrl(imagePath) : null),
      location: json['location'] as String?,
      linkUrl: json['link_url'] as String?,
      isActive: json['is_active'] is bool
          ? json['is_active'] as bool
          : (json['is_active'] as int? ?? 1) == 1,
      companyId: json['company_id'] as int?,
      productCategoryId: json['product_category_id'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
