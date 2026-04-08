/// WebStore Slider Model
///
/// Represents an image slider from the WebStore API.
library;

class SliderModel {
  final int id;
  final String title;
  final String titleAr;
  final String image;
  final int position;

  const SliderModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.image,
    required this.position,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      image: json['image'] as String? ?? '',
      position: json['position'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'image': image,
      'position': position,
    };
  }
}
