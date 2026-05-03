import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/shared/data/datasource/admin_remote_datasource.dart';

class PaymentMethodsRemoteDataSource extends AdminRemoteDataSource {
  PaymentMethodsRemoteDataSource(super.network);

  Future<Map<String, dynamic>> getPaymentMethods({
    int page = 1,
    String? search,
  }) async {
    final res = await network.get(
      ApiEndpoints.webstore.admin.paymentMethods,
      query: {
        'page': page,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    return (res as Map).cast<String, dynamic>();
  }
}
