import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/pages/data/models/cms_page_model.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/home/data/cms_repository.dart';

/// Provider for the list of CMS pages using modern Riverpod 3.0 Notifier pattern
final cmsPagesProvider = NotifierProvider<CmsPagesViewModel, AsyncValue<List<CmsPageModel>>>(() {
  return CmsPagesViewModel();
});

class CmsPagesViewModel extends Notifier<AsyncValue<List<CmsPageModel>>> {
  @override
  AsyncValue<List<CmsPageModel>> build() {
    // Initial fetch
    Future.microtask(() => fetchPages());
    return const AsyncValue.loading();
  }

  ICMSRepository get _repository => ref.read(cmsRepositoryProvider);

  Future<void> fetchPages() async {
    state = const AsyncValue.loading();
    final result = await _repository.getPages();

    result.when(
      success: (data) {
        final List<dynamic> pagesJson = data['data'] ?? [];
        final pages = pagesJson.map((e) => CmsPageModel.fromJson(e)).toList();
        state = AsyncValue.data(pages);
      },
      failure: (error) {
        state = AsyncValue.error(error.message, StackTrace.current);
      },
    );
  }
}
