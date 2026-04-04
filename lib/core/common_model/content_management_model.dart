library;

/// Content Management Model (CMS)
/// Used for dynamic content, advertisements, and marketing banners with HTML support.

class ContentManagementModel {
  final List<ContentManagementItem>? items;

  const ContentManagementModel({this.items});

  factory ContentManagementModel.fromJson(Map<String, dynamic> json) {
    return ContentManagementModel(
      items: json['items'] != null
          ? (json['items'] as List)
              .map((i) => ContentManagementItem.fromJson(i))
              .toList()
          : null,
    );
  }
}

class ContentManagementItem {
  final int id;
  final String title;
  final String? content;
  final String image;
  final String? link;

  const ContentManagementItem({
    required this.id,
    required this.title,
    this.content,
    required this.image,
    this.link,
  });

  factory ContentManagementItem.fromJson(Map<String, dynamic> json) {
    return ContentManagementItem(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      image: json['image'] as String,
      link: json['link'] as String?,
    );
  }
}
