class SliderModel {
  final int id;
  final String? title;
  final String? titleAr;
  final String image;
  final String? linkUrl;

  const SliderModel({
    required this.id,
    this.title,
    this.titleAr,
    required this.image,
    this.linkUrl,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    String imagePath = json['image'] as String? ?? '';
    
    // Ensure full URL for slider images with the correct /storage/ prefix
    if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
      imagePath = 'https://moon-erp.elbaset.com/storage/$cleanPath';
    }

    return SliderModel(
      id: json['id'] as int,
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      image: imagePath,
      linkUrl: json['title_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'image': image,
      'title_url': linkUrl,
    };
  }
}
