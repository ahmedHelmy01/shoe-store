class BoardingRow {
  final int id;
  final String title;
  final String? titleAr;
  final String? image;
  final String? description;
  final int sortOrder;

  const BoardingRow({
    required this.id,
    required this.title,
    this.titleAr,
    this.image,
    this.description,
    required this.sortOrder,
  });

  factory BoardingRow.fromJson(Map<String, dynamic> json) {
    return BoardingRow(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}
