import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';

class ClientReportsRemoteDataSource {
  final NetworkService network;

  ClientReportsRemoteDataSource(this.network);

  Future<Map<String, dynamic>> getClientReport({
    required int customerId,
    required String dateFrom,
    required String dateTo,
  }) async {
    final res = await network.get(
      ApiEndpoints.webstore.admin.clientReport(customerId),
      query: {
        'dateFrom': dateFrom,
        'dateTo': dateTo,
      },
    );
    return (res as Map).cast<String, dynamic>();
  }
}