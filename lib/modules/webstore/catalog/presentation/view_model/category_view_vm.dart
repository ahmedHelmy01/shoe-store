import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';

class SelectedCategoryNotifier extends Notifier<int> {
  @override
  int build() {
    return WebStoreMockData.categories.first.id;
  }

  void select(int id) {
    state = id;
  }
}

final selectedCategoryIdProvider = NotifierProvider<SelectedCategoryNotifier, int>(() {
  return SelectedCategoryNotifier();
});

final categoryContentProvider = Provider<MockCategory>((ref) {
  final selectedId = ref.watch(selectedCategoryIdProvider);
  return WebStoreMockData.categories.firstWhere(
    (c) => c.id == selectedId,
    orElse: () => WebStoreMockData.categories.first,
  );
});
