import 'package:image_picker/image_picker.dart' show XFile;
import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class PrescriptionsRemoteDataSource {
  final NetworkService _networkService;

  PrescriptionsRemoteDataSource(this._networkService);

  Future<dynamic> getPrescriptions({int page = 1, int perPage = 15}) {
    return _networkService.get(
      ApiEndpoints.webstore.prescriptions.index,
      query: {
        'page': page,
        'per_page': perPage,
      },
    );
  }

  Future<dynamic> getPrescriptionDetails(int id) {
    return _networkService.get(
      ApiEndpoints.withId(ApiEndpoints.webstore.prescriptions.detail, id),
    );
  }

  Future<dynamic> createPrescription({
    required XFile imageFile,
    required String note,
    void Function(double)? onProgress,
  }) {
    return _networkService.postMultipart(
      ApiEndpoints.webstore.prescriptions.index,
      fields: {'note': note},
      files: {'image': imageFile},
      onProgress: onProgress,
    );
  }

  Future<dynamic> updatePrescription(
    int id, {
    XFile? imageFile,
    String? imagePath,
    required String note,
  }) {
    final endpoint = ApiEndpoints.withId(ApiEndpoints.webstore.prescriptions.detail, id);
    if (imageFile != null) {
      return _networkService.putMultipart(
        endpoint,
        fields: {'note': note},
        files: {'image': imageFile},
      );
    }
    return _networkService.put(
      endpoint,
      body: {
        'image': imagePath,
        'note': note,
      },
    );
  }

  Future<dynamic> deletePrescription(int id) {
    return _networkService.delete(
      ApiEndpoints.withId(ApiEndpoints.webstore.prescriptions.detail, id),
    );
  }
}
