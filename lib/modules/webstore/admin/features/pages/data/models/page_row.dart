import 'package:erp/core/network/network_url.dart';

class PageRow {
  final int id;
  final String title;
  final String? titleAr;
  final String? content;
  final String? contentAr;
  final String slug;
  final String? image;
  final String? imageUrl;
  final bool isActive;
  final int? companyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PageRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.content,
    this.contentAr,
    required this.slug,
    this.image,
    this.imageUrl,
    required this.isActive,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  factory PageRow.fromJson(Map<String, dynamic> json) {
    final imagePath = json['image'] as String?;
    final providedUrl = json['image_url'] as String?;

    return PageRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      content: json['content'] as String?,
      contentAr: json['content_ar'] as String?,
      slug: json['slug'] as String? ?? '',
      image: imagePath,
      imageUrl: (providedUrl != null && providedUrl.isNotEmpty)
          ? providedUrl
          : (imagePath != null ? NetworkUrl.fullUrl(imagePath) : null),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      companyId: json['company_id'] as int?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }
}
