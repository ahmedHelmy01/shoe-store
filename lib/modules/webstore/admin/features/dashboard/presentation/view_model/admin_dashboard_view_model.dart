import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/admin_statistics_model.dart';
import '../../data/repositories/admin_dashboard_repository.dart';

class AdminDashboardState {
  final bool isLoading;
  final String? error;
  final AdminStatisticsModel? statistics;

  AdminDashboardState({
    this.isLoading = false,
    this.error,
    this.statistics,
  });

  AdminDashboardState copyWith({
    bool? isLoading,
    String? error,
    AdminStatisticsModel? statistics,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      statistics: statistics ?? this.statistics,
    );
  }
}

class AdminDashboardNotifier extends Notifier<AdminDashboardState> {
  @override
  AdminDashboardState build() {
    // Initial fetch
    Future.microtask(() => getStatistics());
    return AdminDashboardState(isLoading: true);
  }

  Future<void> getStatistics() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(adminDashboardRepositoryProvider);
      final stats = await repo.getStatistics();
      state = state.copyWith(isLoading: false, statistics: stats);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final adminDashboardProvider =
    NotifierProvider.autoDispose<AdminDashboardNotifier, AdminDashboardState>(AdminDashboardNotifier.new);
