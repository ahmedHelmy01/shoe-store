import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/services/location_service.dart';

// ─── Location State ─────────────────────────────────

class LocationState {
  final String? selectedBranch;
  final double? latitude;
  final double? longitude;

  LocationState({this.selectedBranch, this.latitude, this.longitude});

  LocationState copyWith({
    String? selectedBranch,
    double? latitude,
    double? longitude,
  }) {
    return LocationState(
      selectedBranch: selectedBranch ?? this.selectedBranch,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

// ─── Location View Model ────────────────────────────

class LocationVm extends Notifier<LocationState> {
  @override
  LocationState build() {
    _initLocation();
    return LocationState(selectedBranch: 'الفرع الرئيسي');
  }

  Future<void> _initLocation() async {
    final branch = await ref.read(sessionManagerProvider).getBranchName();
    if (branch != null) {
      state = state.copyWith(selectedBranch: branch);
    }
  }

  Future<void> requestLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
  }

  void updateSelectedBranch(String branch) async {
    state = state.copyWith(selectedBranch: branch);
    await ref.read(sessionManagerProvider).setBranchName(branch);
  }
}

final locationProvider = NotifierProvider<LocationVm, LocationState>(
  LocationVm.new,
);
