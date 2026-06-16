class AdminPrescriptionRow {
  final int id;
  final int companyId;
  final int customerId;
  final String? note;
  final String image;
  final String imageUrl;
  final String status;
  final int? reviewedBy;
  final AdminReviewer? reviewer;
  final AdminCustomer? customer;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminPrescriptionRow({
    required this.id,
    required this.companyId,
    required this.customerId,
    this.note,
    required this.image,
    required this.imageUrl,
    required this.status,
    this.reviewedBy,
    this.reviewer,
    this.customer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminPrescriptionRow.fromJson(Map<String, dynamic> json) {
    return AdminPrescriptionRow(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      customerId: json['customer_id'] as int,
      note: json['note'] as String?,
      image: json['image'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      reviewedBy: json['reviewed_by'] as int?,
      reviewer: json['reviewer'] != null
          ? AdminReviewer.fromJson(json['reviewer'] as Map<String, dynamic>)
          : null,
      customer: json['customer'] != null
          ? AdminCustomer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class AdminReviewer {
  final int id;
  final String name;

  AdminReviewer({required this.id, required this.name});

  factory AdminReviewer.fromJson(Map<String, dynamic> json) {
    return AdminReviewer(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown',
    );
  }
}

class AdminCustomer {
  final int id;
  final String name;
  final String? mobile;

  AdminCustomer({required this.id, required this.name, this.mobile});

  factory AdminCustomer.fromJson(Map<String, dynamic> json) {
    return AdminCustomer(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Guest',
      mobile: json['mobile'] as String?,
    );
  }
}
