class AdRow {
  final int id;
  final String title;
  final String? titleAr;
  final String? image;
  final String? location;
  final bool isActive;

  const AdRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.image,
    this.location,
    required this.isActive,
  });

  factory AdRow.fromJson(Map<String, dynamic> json) {
    return AdRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      image: json['image'] as String?,
      location: json['location'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
