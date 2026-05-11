import 'package:image_picker/image_picker.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/datasource/boardings_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/models/boarding_row.dart';

abstract class IBoardingsRepository {
  Future<ApiResult<AdminPagedResponse<BoardingRow>>> getBoardings({
    int page = 1,
    String? search,
  });

  Future<ApiResult<BoardingRow>> saveBoarding(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress});

  Future<ApiResult<void>> deleteBoarding(int id);
}

class BoardingsRepository extends AdminBaseRepository implements IBoardingsRepository {
  final BoardingsRemoteDataSource _ds;

  BoardingsRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<BoardingRow>>> getBoardings({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getBoardings(page: page, search: search);
      return parsePaged(json, page, (j) => BoardingRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<BoardingRow>> saveBoarding(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress}) {
    return safeApiCall(() async {
      final path = id == null
          ? ApiEndpoints.webstore.admin.boardings
          : ApiEndpoints.withId(ApiEndpoints.webstore.admin.boardings, id);

      final Map<String, dynamic> json;
      if (imageFile != null) {
        final fields = toMultipartFields(data);
        json = id == null
            ? await _ds.postMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress)
            : await _ds.putMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress);
      } else {
        json = id == null ? await _ds.postData(path, data) : await _ds.putData(path, data);
      }
      return parseSingle(json, (j) => BoardingRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteBoarding(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.boardings, id),
      );
    });
  }
}
