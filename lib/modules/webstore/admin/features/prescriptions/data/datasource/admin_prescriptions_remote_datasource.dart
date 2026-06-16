import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class AdminPrescriptionsRemoteDataSource {
  final NetworkService _ns;

  AdminPrescriptionsRemoteDataSource(this._ns);

  Future<Map<String, dynamic>> getPrescriptions({
    int page = 1,
    String? status,
    int? customerId,
    int? perPage,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      if (status != null) 'status': status,
      if (customerId != null) 'customer_id': customerId,
      if (perPage != null) 'per_page': perPage,
    };

    return await _ns.get(ApiEndpoints.webstore.admin.prescriptions, query: queryParams);
  }

  Future<Map<String, dynamic>> getPrescription(int id) async {
    return await _ns.get(ApiEndpoints.withId(ApiEndpoints.webstore.admin.prescriptions, id));
  }

  Future<Map<String, dynamic>> reviewPrescription(int id, Map<String, dynamic> data) async {
    final path = '${ApiEndpoints.withId(ApiEndpoints.webstore.admin.prescriptions, id)}/review';
    return await _ns.post(path, body: data);
  }
}
