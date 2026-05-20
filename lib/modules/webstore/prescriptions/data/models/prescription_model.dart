class PrescriptionModel {
  final int id;
  final int companyId;
  final int customerId;
  final String note;
  final String image;
  final String status;
  final dynamic reviewedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  PrescriptionModel({
    required this.id,
    required this.companyId,
    required this.customerId,
    required this.note,
    required this.image,
    required this.status,
    this.reviewedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      customerId: json['customer_id'] as int,
      note: json['note'] as String? ?? '',
      image: json['image'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      reviewedBy: json['reviewed_by'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'customer_id': customerId,
      'note': note,
      'image': image,
      'status': status,
      'reviewed_by': reviewedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
