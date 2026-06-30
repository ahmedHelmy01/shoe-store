import 'package:image_picker/image_picker.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/offers/data/datasource/offers_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/data/repositories/admin_base_repository.dart';
import 'package:erp/modules/webstore/admin/features/offers/data/models/offer_row.dart';

abstract class IOffersRepository {
  Future<ApiResult<AdminPagedResponse<OfferRow>>> getOffers({
    int page = 1,
    String? search,
  });

  Future<ApiResult<OfferRow>> getOffer(int id);

  Future<ApiResult<OfferRow>> saveOffer(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress});

  Future<ApiResult<void>> deleteOffer(int id);
}

class OffersRepository extends AdminBaseRepository implements IOffersRepository {
  final OffersRemoteDataSource _ds;

  OffersRepository(this._ds);

  @override
  Future<ApiResult<AdminPagedResponse<OfferRow>>> getOffers({
    int page = 1,
    String? search,
  }) {
    return safeApiCall(() async {
      final json = await _ds.getOffers(page: page, search: search);
      return parsePaged(json, page, (j) => OfferRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<OfferRow>> getOffer(int id) {
    return safeApiCall(() async {
      final json = await _ds.getOffer(id);
      return parseSingle(json, (j) => OfferRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<OfferRow>> saveOffer(Map<String, dynamic> data, {int? id, XFile? imageFile, void Function(double)? onProgress}) {
    return safeApiCall(() async {
      final path = id == null
          ? ApiEndpoints.webstore.admin.offers
          : ApiEndpoints.withId(ApiEndpoints.webstore.admin.offers, id);

      final Map<String, dynamic> json;
      if (imageFile != null) {
        final fields = toMultipartFields(data);
        json = id == null
            ? await _ds.postMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress)
            : await _ds.putMultipart(path, fields: fields, files: {'image': imageFile}, onProgress: onProgress);
      } else {
        json = id == null ? await _ds.postData(path, data) : await _ds.putData(path, data);
      }
      return parseSingle(json, (j) => OfferRow.fromJson(j));
    });
  }

  @override
  Future<ApiResult<void>> deleteOffer(int id) {
    return safeApiCall(() async {
      await _ds.deleteData(
        ApiEndpoints.withId(ApiEndpoints.webstore.admin.offers, id),
      );
    });
  }
}
