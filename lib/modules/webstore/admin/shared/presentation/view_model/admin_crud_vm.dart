import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';

/// Base State for all Admin CRUD features.
sealed class AdminCrudState<T> {
  final T? editingItem;
  final bool isAdding;
  final bool isSaving;
  final double uploadProgress;

  const AdminCrudState({
    this.editingItem,
    this.isAdding = false,
    this.isSaving = false,
    this.uploadProgress = 0,
  });

  AdminCrudState<T> copyWithUi({
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    double? uploadProgress,
    bool clearEditing = false,
  });
}

class AdminCrudLoading<T> extends AdminCrudState<T> {
  const AdminCrudLoading({
    super.editingItem,
    super.isAdding,
    super.isSaving,
    super.uploadProgress,
  });

  @override
  AdminCrudLoading<T> copyWithUi({
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    double? uploadProgress,
    bool clearEditing = false,
  }) {
    return AdminCrudLoading<T>(
      editingItem: clearEditing ? null : (editingItem ?? this.editingItem),
      isAdding: isAdding ?? (clearEditing ? false : this.isAdding),
      isSaving: isSaving ?? this.isSaving,
      uploadProgress: uploadProgress ?? this.uploadProgress,
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
    super.uploadProgress,
  });

  @override
  AdminCrudError<T> copyWithUi({
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    double? uploadProgress,
    bool clearEditing = false,
  }) {
    return AdminCrudError<T>(
      message,
      editingItem: clearEditing ? null : (editingItem ?? this.editingItem),
      isAdding: isAdding ?? (clearEditing ? false : this.isAdding),
      isSaving: isSaving ?? this.isSaving,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}

class AdminCrudData<T> extends AdminCrudState<T> {
  final List<T> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;
  final int perPage;

  const AdminCrudData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
    required this.perPage,
    super.editingItem,
    super.isAdding = false,
    super.isSaving = false,
    super.uploadProgress = 0,
  });

  bool get canPrev => page > 1;

  bool get canNext =>
      lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);

  bool get hasMore => canNext;

  @override
  AdminCrudData<T> copyWithUi({
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    double? uploadProgress,
    bool clearEditing = false,
  }) {
    return copyWith(
      editingItem: editingItem,
      isAdding: isAdding,
      isSaving: isSaving,
      uploadProgress: uploadProgress,
      clearEditing: clearEditing,
    );
  }

  AdminCrudData<T> copyWith({
    List<T>? items,
    int? page,
    int? lastPage,
    int? total,
    String? search,
    int? perPage,
    T? editingItem,
    bool? isAdding,
    bool? isSaving,
    double? uploadProgress,
    bool clearEditing = false,
  }) {
    return AdminCrudData<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      search: search ?? this.search,
      perPage: perPage ?? this.perPage,
      editingItem: clearEditing ? null : (editingItem ?? this.editingItem),
      isAdding: isAdding ?? (clearEditing ? false : this.isAdding),
      isSaving: isSaving ?? this.isSaving,
      uploadProgress: uploadProgress ?? this.uploadProgress,
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
  int _perPage = 10;

  /// Implement this to call the specific repository method.
  Future<ApiResult<AdminPagedResponse<T>>> getItems({
    required int page,
    String? search,
    int? perPage,
  });

  /// Implement this to save (create or update) an item.
  /// Pass onProgress if you want to support progress tracking.
  Future<ApiResult<T>> saveItem(
    Map<String, dynamic> data, {
    dynamic id,
    XFile? imageFile,
    Map<String, dynamic>? extraData,
    void Function(double)? onProgress,
  });

  /// Implement this to delete an item.
  Future<ApiResult<void>> deleteItem(dynamic id);

  Future<void> fetch({String? search, int? page, int? perPage}) async {
    if (search != null) _search = search;
    if (page != null) _page = page;
    if (perPage != null) _perPage = perPage;

    final s = state;
    state = AdminCrudLoading<T>(
      editingItem: s.editingItem,
      isAdding: s.isAdding,
      isSaving: s.isSaving,
      uploadProgress: s.uploadProgress,
    );

    final res = await getItems(page: _page, search: _search, perPage: _perPage);

    res.when(
      success: (paged) {
        state = AdminCrudData<T>(
          items: paged.items,
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
          search: _search,
          perPage: _perPage,
          editingItem: state.editingItem,
          isAdding: state.isAdding,
          isSaving: state.isSaving,
          uploadProgress: state.uploadProgress,
        );
      },
      failure: (e) {
        state = AdminCrudError<T>(
          e.message,
          editingItem: state.editingItem,
          isAdding: state.isAdding,
          isSaving: state.isSaving,
          uploadProgress: state.uploadProgress,
        );
      },
    );
  }

  void openAdd() {
    state = state.copyWithUi(
      clearEditing: true,
      isAdding: true,
      uploadProgress: 0,
    );
  }

  void openEdit(T item) {
    state = state.copyWithUi(
      editingItem: item,
      isAdding: false,
      uploadProgress: 0,
    );
  }

  void closePanel() {
    state = state.copyWithUi(
      clearEditing: true,
      isAdding: false,
      isSaving: false,
      uploadProgress: 0,
    );
  }

  Future<bool> commitSave(
    Map<String, dynamic> body, {
    dynamic id,
    XFile? imageFile,
    Map<String, dynamic>? extraData,
  }) async {
    final s = state;
    state = s.copyWithUi(isSaving: true, uploadProgress: 0);

    final res = await saveItem(
      body,
      id: id,
      imageFile: imageFile,
      extraData: extraData,
      onProgress: (p) => state = state.copyWithUi(uploadProgress: p),
    );

    return res.when(
      success: (_) {
        fetch(page: _page); // Refresh list
        return true;
      },
      failure: (e) {
        state = state.copyWithUi(isSaving: false, uploadProgress: 0);
        AppStatusDialog.lastApiError = e.message;
        return false;
      },
    );
  }

  Future<bool> commitDelete(dynamic id) async {
    final res = await deleteItem(id);
    return res.when(
      success: (_) {
        fetch(page: _page);
        return true;
      },
      failure: (e) {
        AppStatusDialog.lastApiError = e.message;
        return false;
      },
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

  Future<void> fetchMore() async {
    final s = state;
    if (s is! AdminCrudData<T> || !s.canNext || s is AdminCrudLoading) return;

    _page = s.page + 1;
    final res = await getItems(page: _page, search: _search, perPage: _perPage);

    res.when(
      success: (paged) {
        state = s.copyWith(
          items: [...s.items, ...paged.items],
          page: paged.page,
          lastPage: paged.lastPage,
          total: paged.total,
        );
      },
      failure: (_) {},
    );
  }
}
