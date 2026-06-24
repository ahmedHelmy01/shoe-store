import 'package:erp/core/network/network_url.dart';

class CompanyRow {
  final int id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String? logo;
  final String? logoUrl;
  final bool isActive;

  const CompanyRow({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.logo,
    this.logoUrl,
    required this.isActive,
  });

  factory CompanyRow.fromJson(Map<String, dynamic> json) {
    final logoPath = json['logo'] as String?;
    final providedUrl = json['logo_url'] as String?;
    
    return CompanyRow(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? json['name_en'] as String? ?? 'Unknown',
      nameAr: json['name_ar'] as String?,
      description: json['description_en'] as String? ?? json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      logo: logoPath,
      logoUrl: providedUrl ?? (logoPath != null ? NetworkUrl.fullUrl(logoPath) : null),
      isActive: (json['active'] ?? json['is_active'] ?? true) as bool,
    );
  }
}
