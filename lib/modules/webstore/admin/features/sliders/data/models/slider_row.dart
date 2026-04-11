class SliderRow {
  final int id;
  final String title;
  final String? titleAr;
  final String? image;
  final String? link;
  final bool isActive;

  const SliderRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.image,
    this.link,
    required this.isActive,
  });

  factory SliderRow.fromJson(Map<String, dynamic> json) {
    return SliderRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      image: json['image'] as String?,
      link: json['link'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
