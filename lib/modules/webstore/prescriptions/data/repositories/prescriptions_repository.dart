import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/pagination/paginated_response.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:erp/modules/webstore/prescriptions/data/datasource/prescriptions_remote_datasource.dart';
import 'package:erp/modules/webstore/prescriptions/data/models/prescription_model.dart';

abstract class IPrescriptionsRepository {
  Future<ApiResult<PaginatedResponse<PrescriptionModel>>> getPrescriptions({int page = 1});
  Future<ApiResult<PrescriptionModel>> getPrescriptionDetails(int id);
  Future<ApiResult<PrescriptionModel>> createPrescription({
    required XFile imageFile,
    required String note,
    void Function(double)? onProgress,
  });
  Future<ApiResult<PrescriptionModel>> updatePrescription(
    int id, {
    XFile? newImageFile,
    String? currentImagePath,
    required String note,
  });
  Future<ApiResult<void>> deletePrescription(int id);
}

class PrescriptionsRepository extends BaseRepository implements IPrescriptionsRepository {
  final PrescriptionsRemoteDataSource _remoteDataSource;

  PrescriptionsRepository(this._remoteDataSource);

  @override
  Future<ApiResult<PaginatedResponse<PrescriptionModel>>> getPrescriptions({int page = 1}) {
    return safeApiCall<PaginatedResponse<PrescriptionModel>>(() async {
      final response = await _remoteDataSource.getPrescriptions(page: page);
      return PaginatedResponse<PrescriptionModel>.fromJson(
        response,
        (json) => PrescriptionModel.fromJson(json),
      );
    });
  }

  @override
  Future<ApiResult<PrescriptionModel>> getPrescriptionDetails(int id) {
    return safeApiCall<PrescriptionModel>(() async {
      final response = await _remoteDataSource.getPrescriptionDetails(id);
      final data = response['data'] as Map<String, dynamic>;
      return PrescriptionModel.fromJson(data);
    });
  }

  @override
  Future<ApiResult<PrescriptionModel>> createPrescription({
    required XFile imageFile,
    required String note,
    void Function(double)? onProgress,
  }) {
    return safeApiCall<PrescriptionModel>(() async {
      final response = await _remoteDataSource.createPrescription(
        imageFile: imageFile,
        note: note,
        onProgress: onProgress,
      );
      final data = response['data'] as Map<String, dynamic>;
      return PrescriptionModel.fromJson(data);
    });
  }

  @override
  Future<ApiResult<PrescriptionModel>> updatePrescription(
    int id, {
    XFile? newImageFile,
    String? currentImagePath,
    required String note,
  }) {
    return safeApiCall<PrescriptionModel>(() async {
      final response = await _remoteDataSource.updatePrescription(
        id,
        imageFile: newImageFile,
        imagePath: currentImagePath,
        note: note,
      );
      final data = response['data'] as Map<String, dynamic>;
      return PrescriptionModel.fromJson(data);
    });
  }

  @override
  Future<ApiResult<void>> deletePrescription(int id) {
    return safeApiCall<void>(() async {
      await _remoteDataSource.deletePrescription(id);
    });
  }
}
