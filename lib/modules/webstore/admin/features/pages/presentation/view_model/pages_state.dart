import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';

sealed class PagesState {
  const PagesState();
}

class PagesLoading extends PagesState {
  const PagesLoading();
}

class PagesError extends PagesState {
  final String message;
  const PagesError(this.message);
}

class PagesData extends PagesState {
  final List<PageRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const PagesData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
