/// ERP System - Base Model Mixin
///
/// Provides common serialization interface for all models.
library;

/// Mixin for models that can be serialized to/from JSON
mixin JsonSerializable {
  Map<String, dynamic> toJson();
}

/// Base entity class with common fields
abstract class BaseEntity {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BaseEntity({this.id, this.createdAt, this.updatedAt});
}

/// Common lookup model used across many modules (dropdowns, etc.)
class LookupModel {
  final int id;
  final String name;
  final String? nameEn;
  final String? code;
  final bool? isActive;

  const LookupModel({
    required this.id,
    required this.name,
    this.nameEn,
    this.code,
    this.isActive,
  });

  factory LookupModel.fromJson(Map<String, dynamic> json) {
    return LookupModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['name_ar'] ?? '',
      nameEn: json['name_en'],
      code: json['code'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (nameEn != null) 'name_en': nameEn,
    if (code != null) 'code': code,
    if (isActive != null) 'is_active': isActive,
  };

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LookupModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// File upload model for multipart uploads
class FileUploadModel {
  final String filePath;
  final String fileName;
  final String? mimeType;
  final String fieldName;

  const FileUploadModel({
    required this.filePath,
    required this.fileName,
    this.mimeType,
    this.fieldName = 'file',
  });
}

/// Generic API response wrapper
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonData,
  ) {
    return ApiResponse(
      success: json['success'] ?? json['status'] == true,
      message: json['message'],
      data: json['data'] != null && fromJsonData != null
          ? fromJsonData(json['data'])
          : null,
    );
  }
}
