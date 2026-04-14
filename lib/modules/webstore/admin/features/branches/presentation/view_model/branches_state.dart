import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';

sealed class BranchesState {
  const BranchesState();
}

class BranchesLoading extends BranchesState {
  const BranchesLoading();
}

class BranchesError extends BranchesState {
  final String message;
  const BranchesError(this.message);
}

class BranchesData extends BranchesState {
  final List<BranchRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const BranchesData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
