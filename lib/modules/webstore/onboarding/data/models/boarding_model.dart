/// Boarding Model
///
/// Represents an onboarding screen from the WebStore API.
library;

class BoardingModel {
  final int id;
  final String title;
  final String titleAr;
  final String content;
  final String contentAr;
  final String image;
  final int position;

  const BoardingModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.content,
    required this.contentAr,
    required this.image,
    required this.position,
  });

  factory BoardingModel.fromJson(Map<String, dynamic> json) {
    return BoardingModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      content: json['content'] as String? ?? '',
      contentAr: json['content_ar'] as String? ?? '',
      image: json['image_url'] as String? ?? '',
      position: json['position'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'content': content,
      'content_ar': contentAr,
      'image': image,
      'position': position,
    };
  }
}
