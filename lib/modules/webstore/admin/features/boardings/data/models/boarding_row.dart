import 'package:erp/core/network/network_url.dart';

class BoardingRow {
  final int id;
  final String title;
  final String? titleAr;
  final String? content;
  final String? contentAr;
  final String? image;
  final String? imageUrl;
  final int position;
  final bool isActive;
  final int? companyId;
  final String? createdAt;
  final String? updatedAt;

  const BoardingRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.content,
    this.contentAr,
    this.image,
    this.imageUrl,
    required this.position,
    required this.isActive,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  factory BoardingRow.fromJson(Map<String, dynamic> json) {
    final imagePath = json['image'] as String?;
    final providedUrl = json['image_url'] as String?;

    return BoardingRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      content: json['content'] as String?,
      contentAr: json['content_ar'] as String?,
      image: imagePath,
      imageUrl: (providedUrl != null && providedUrl.isNotEmpty)
          ? providedUrl
          : (imagePath != null ? NetworkUrl.fullUrl(imagePath) : null),
      position: json['position'] as int? ?? 0,
      isActive: json['is_active'] is bool
          ? json['is_active'] as bool
          : (json['is_active'] as int? ?? 1) == 1,
      companyId: json['company_id'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
