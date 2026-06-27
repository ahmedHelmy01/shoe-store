import 'package:erp/modules/webstore/admin/features/settings/data/models/store_settings_model.dart';
import 'package:erp/modules/webstore/admin/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminSettingsState {
  final bool isSaving;
  final String? error;
  final bool isSuccess;

  const AdminSettingsState({
    this.isSaving = false,
    this.error,
    this.isSuccess = false,
  });

  AdminSettingsState copyWith({
    bool? isSaving,
    String? error,
    bool? isSuccess,
  }) {
    return AdminSettingsState(
      isSaving: isSaving ?? this.isSaving,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AdminSettingsNotifier extends Notifier<AdminSettingsState> {
  @override
  AdminSettingsState build() => const AdminSettingsState();

  Future<void> updateSettings(StoreSettingsModel settings) async {
    state = state.copyWith(isSaving: true, isSuccess: false, error: null);
    final repo = ref.read(adminSettingsRepositoryProvider);
    final result = await repo.updateSettings(settings);
    result.when(
      success: (_) => state = state.copyWith(isSaving: false, isSuccess: true),
      failure: (e) => state = state.copyWith(isSaving: false, error: e.message),
    );
  }

  void clearStates() {
    state = const AdminSettingsState();
  }
}

final adminSettingsProvider = NotifierProvider<AdminSettingsNotifier, AdminSettingsState>(
  AdminSettingsNotifier.new,
);
