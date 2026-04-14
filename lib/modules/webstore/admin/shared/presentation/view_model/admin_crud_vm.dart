import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';

/// Base State for all Admin CRUD features.
sealed class AdminCrudState<T> {
  final T? editingItem;
  final bool isAdding;
  final bool isSaving;

  const AdminCrudState({
    this.editingItem,
    this.isAdding = false,
    this.isSaving = false,
  });

  AdminCrudState<T> copyWithUi({
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    bool clearEditing = false,
  });
}

class AdminCrudLoading<T> extends AdminCrudState<T> {
  const AdminCrudLoading({
    super.editingItem,
    super.isAdding,
    super.isSaving,
  });

  @override
  AdminCrudLoading<T> copyWithUi({
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    bool clearEditing = false,
  }) {
    return AdminCrudLoading<T>(
      editingItem: clearEditing ? null : (editingItem ?? this.editingItem),
      isAdding: isAdding ?? (clearEditing ? false : this.isAdding),
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class AdminCrudError<T> extends AdminCrudState<T> {
  final String message;
  const AdminCrudError(
    this.message, {
    super.editingItem,
    super.isAdding,
    super.isSaving,
  });

  @override
  AdminCrudError<T> copyWithUi({
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    bool clearEditing = false,
  }) {
    return AdminCrudError<T>(
      message,
      editingItem: clearEditing ? null : (editingItem ?? this.editingItem),
      isAdding: isAdding ?? (clearEditing ? false : this.isAdding),
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class AdminCrudData<T> extends AdminCrudState<T> {
  final List<T> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const AdminCrudData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
    super.editingItem,
    super.isAdding = false,
    super.isSaving = false,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);

  @override
  AdminCrudData<T> copyWithUi({
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    bool clearEditing = false,
  }) {
    return copyWith(
      editingItem: editingItem,
      isAdding: isAdding,
      isSaving: isSaving,
      clearEditing: clearEditing,
    );
  }

  AdminCrudData<T> copyWith({
    List<T>? items,
    int? page,
    int? lastPage,
    int? total,
    String? search,
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    bool clearEditing = false,
  }) {
    return AdminCrudData<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      search: search ?? this.search,
      editingItem: clearEditing ? null : (editingItem ?? this.editingItem),
      isAdding: isAdding ?? (clearEditing ? false : this.isAdding),
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

/// A Generic Notifier for all Admin Features to ensure DRY (Don't Repeat Yourself) code.
abstract class AdminCrudVm<T> extends Notifier<AdminCrudState<T>> {
  @override
  AdminCrudState<T> build() {
    Future.microtask(() => fetch());
    return AdminCrudLoading<T>();
  }

  String _search = '';
  int _page = 1;

  /// Implement this to call the specific repository method.
  Future<ApiResult<AdminPagedResponse<T>>> getItems({required int page, String? search});

  /// Implement this to save (create or update) an item.
  Future<ApiResult<T>> saveItem(Map<String, dynamic> data, {dynamic id});

  /// Implement this to delete an item.
  Future<ApiResult<void>> deleteItem(dynamic id);

  Future<void> fetch({String? search, int? page}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;

    // Preserving UI flags during transitions
    final s = state;
    state = AdminCrudLoading<T>(
      editingItem: s.editingItem,
      isAdding: s.isAdding,
      isSaving: s.isSaving,
    );
    
    final res = await getItems(page: _page, search: _search);

    res.when(
      success: (paged) {
        state = AdminCrudData<T>(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
          editingItem: state.editingItem,
          isAdding: state.isAdding,
          isSaving: state.isSaving,
        );
      },
      failure: (e) {
        state = AdminCrudError<T>(
          e.message,
          editingItem: state.editingItem,
          isAdding: state.isAdding,
          isSaving: state.isSaving,
        );
      },
    );
  }

  void openAdd() {
    state = state.copyWithUi(clearEditing: true, isAdding: true);
  }

  void openEdit(T item) {
    state = state.copyWithUi(editingItem: item, isAdding: false);
  }

  void closePanel() {
    state = state.copyWithUi(clearEditing: true, isAdding: false, isSaving: false);
  }

  Future<bool> commitSave(Map<String, dynamic> body, {dynamic id}) async {
    final s = state;
    state = s.copyWithUi(isSaving: true);
    
    final res = await saveItem(body, id: id);

    return res.when(
      success: (_) {
        fetch(page: _page); // Refresh list
        return true;
      },
      failure: (e) {
        state = state.copyWithUi(isSaving: false);
        return false;
      },
    );
  }

  Future<void> commitDelete(dynamic id) async {
    final res = await deleteItem(id);
    res.when(
      success: (_) => fetch(page: _page),
      failure: (e) => {}, // Handle error
    );
  }

  Future<void> nextPage() async {
    final s = state;
    if (s is! AdminCrudData<T> || !s.canNext) return;
    await fetch(page: s.page + 1);
  }

  Future<void> prevPage() async {
    final s = state;
    if (s is! AdminCrudData<T> || !s.canPrev) return;
    await fetch(page: s.page - 1);
  }
}
