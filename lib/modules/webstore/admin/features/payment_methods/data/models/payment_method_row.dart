import 'package:erp/core/network/network_url.dart';

class PaymentMethodRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? nameEn;
  final String? note;
  final String? noteAr;
  final String? image;
  final String? imageUrl;
  final String type;
  final bool isActive;
  final int sortOrder;

  const PaymentMethodRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.nameEn,
    this.note,
    this.noteAr,
    this.image,
    this.imageUrl,
    required this.type,
    required this.isActive,
    required this.sortOrder,
  });

  factory PaymentMethodRow.fromJson(Map<String, dynamic> json) {
    final imagePath = json['image'] as String?;
    final providedUrl = json['image_url'] as String?;

    return PaymentMethodRow(
      id: json['id'] as int? ?? 0,
      name: (json['name'] ?? json['title']) as String? ?? '',
      nameAr: (json['name_ar'] ?? json['title_ar']) as String?,
      nameEn: (json['name_en'] ?? json['title_en']) as String?,
      note: json['note'] as String?,
      noteAr: json['note_ar'] as String?,
      image: imagePath,
      imageUrl: (providedUrl != null && providedUrl.isNotEmpty)
          ? providedUrl
          : (imagePath != null ? NetworkUrl.fullUrl(imagePath) : null),
      type: json['type'] as String? ?? 'cod',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'name_ar': nameAr,
      'name_en': nameEn,
      'type': type,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }
}
