import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import '../datasource/client_reports_remote_datasource.dart';
import '../models/client_report_models.dart';

abstract class IClientReportsRepository {
  Future<ApiResult<ClientReport>> getClientReport({
    required int customerId,
    required String dateFrom,
    required String dateTo,
  });
}

class ClientReportsRepository extends BaseRepository implements IClientReportsRepository {
  final ClientReportsRemoteDataSource _ds;

  ClientReportsRepository(this._ds);

  @override
  Future<ApiResult<ClientReport>> getClientReport({
    required int customerId,
    required String dateFrom,
    required String dateTo,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getClientReport(
        customerId: customerId,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      return ClientReport.fromJson(json);
    });
  }
}