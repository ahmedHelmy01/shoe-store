/// Review Model — matches the server response for product reviews
library;

class ReviewModel {
  final int id;
  final int rating;
  final String? review;
  final bool isApproved;
  final ReviewCustomer? customer;

  const ReviewModel({
    required this.id,
    required this.rating,
    this.review,
    this.isApproved = false,
    this.customer,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] as Map<String, dynamic> : json;

    return ReviewModel(
      id: data['id'] as int,
      rating: data['rating'] as int? ?? 0,
      review: data['review'] as String?,
      isApproved: data['is_approved'] as bool? ?? false,
      customer: data['customer'] != null
          ? ReviewCustomer.fromJson(data['customer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'rating': rating,
    'review': review,
    'is_approved': isApproved,
  };
}

class ReviewCustomer {
  final int id;
  final String name;

  const ReviewCustomer({required this.id, required this.name});

  factory ReviewCustomer.fromJson(Map<String, dynamic> json) {
    return ReviewCustomer(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}
