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
    required String imagePath,
    required String note,
  }) {
    return _networkService.post(
      ApiEndpoints.webstore.prescriptions.index,
      body: {
        'image': imagePath,
        'note': note,
      },
    );
  }

  Future<dynamic> updatePrescription(
    int id, {
    required String imagePath,
    required String note,
  }) {
    return _networkService.put(
      ApiEndpoints.withId(ApiEndpoints.webstore.prescriptions.detail, id),
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
