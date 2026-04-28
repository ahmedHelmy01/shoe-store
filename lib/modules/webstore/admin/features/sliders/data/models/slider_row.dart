class SliderRow {
  final int id;
  final String title;
  final String? titleAr;
  final String? content;
  final String? contentAr;
  final String? image;
  final String? titleUrl;
  final String? openTarget;
  final String? location;
  final int position;
  final bool isActive;
  final int? companyId;
  final String? createdAt;
  final String? updatedAt;

  const SliderRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.content,
    this.contentAr,
    this.image,
    this.titleUrl,
    this.openTarget,
    this.location,
    required this.position,
    required this.isActive,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  factory SliderRow.fromJson(Map<String, dynamic> json) {
    return SliderRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      content: json['content'] as String?,
      contentAr: json['content_ar'] as String?,
      image: json['image'] as String?,
      titleUrl: json['title_url'] as String?,
      openTarget: json['open_target'] as String?,
      location: json['location'] as String?,
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

