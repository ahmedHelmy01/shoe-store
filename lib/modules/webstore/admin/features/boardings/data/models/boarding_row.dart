class BoardingRow {
  final int id;
  final String title;
  final String? titleAr;
  final String? content;
  final String? contentAr;
  final String? image;
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
    required this.position,
    required this.isActive,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  factory BoardingRow.fromJson(Map<String, dynamic> json) {
    return BoardingRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      content: json['content'] as String?,
      contentAr: json['content_ar'] as String?,
      image: json['image'] as String?,
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
