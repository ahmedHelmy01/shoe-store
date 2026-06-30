import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/offers/data/models/offer_row.dart';

final offersVmProvider = NotifierProvider<OffersVm, AdminCrudState<OfferRow>>(OffersVm.new);

class OffersVm extends AdminCrudVm<OfferRow> {
  @override
  Future<ApiResult<AdminPagedResponse<OfferRow>>> getItems({required int page, String? search, int? perPage}) {
    return ref.read(offersRepositoryProvider).getOffers(page: page, search: search);
  }

  @override
  Future<ApiResult<OfferRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(offersRepositoryProvider).saveOffer(data, id: id as int?, imageFile: imageFile);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(offersRepositoryProvider).deleteOffer(id as int);
  }
}
