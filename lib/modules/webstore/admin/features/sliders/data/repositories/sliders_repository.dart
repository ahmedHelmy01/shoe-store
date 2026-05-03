import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/datasource/sliders_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/models/slider_row.dart';

abstract class ISlidersRepository {
  Future<ApiResult<AdminPagedResponse<SliderRow>>> getSliders({
    int page = 1,
    String? search,
  });

  Future<ApiResult<SliderRow>> saveSlider(Map<String, dynamic> data, {int? id});

  Future<ApiResult<void>> deleteSlider(int id);
}

class SlidersRepository extends AdminBaseRepository implements ISlidersRepository {
  final SlidersRemoteDataSource _ds;

  SlidersRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<SliderRow>>> getSliders({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getSliders(page: page, search: search);
      return parsePaged(json, page, (j) => SliderRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<SliderRow>> saveSlider(Map<String, dynamic> data, {int? id}) {
    return safeApiCall(() async {
      final json = id == null
          ? await _ds.postData(ApiEndpoints.webstore.admin.sliders, data)
          : await _ds.putData(
              ApiEndpoints.withId(ApiEndpoints.webstore.admin.sliders, id),
              data,
            );
      return parseSingle(json, (j) => SliderRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteSlider(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.sliders, id),
      );
    });
  }
}
