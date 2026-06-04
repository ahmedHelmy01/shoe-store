import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/services/location_service.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';
import 'package:erp/modules/webstore/branches/presentation/state/branch_state.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

mixin SplashLogic<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<void> initializeSplash() async {
    final action = await _showLocationChoiceDialog();
    if (!mounted) return;

    if (action == _LocationStartAction.enableLocation) {
      final completed = await _tryEnableLocationFlow();
      if (!completed && mounted) {
        await _loadBranchesForManualSelection(selectAfterLoad: false);
      }
    } else if (action == _LocationStartAction.manualSelect) {
      await _loadBranchesForManualSelection(selectAfterLoad: true);
    } else {
      await _loadBranchesForManualSelection(selectAfterLoad: false);
    }
  }

  Future<bool> _tryEnableLocationFlow() async {
    while (mounted) {
      try {
        await ref.read(locationProvider.notifier).requestLocation();
        final locationState = ref.read(locationProvider);
        if (locationState.latitude == null || locationState.longitude == null) {
          final retry = await _showRetryDialog('تعذر تحديد موقعك الحالي.');
          if (!retry) return false;
          continue;
        }

        await ref.read(branchVmProvider.notifier).getBranches();
        final selected = await _autoSelectNearestBranch(
          lat: locationState.latitude!,
          lng: locationState.longitude!,
        );
        return selected;
      } catch (e) {
        String message = 'يرجى تفعيل الموقع لإظهار أقرب الفروع.';
        VoidCallback? openSettings;
        if (e == LocationErrors.serviceDisabled) {
          message = 'خدمة GPS متوقفة، قم بتفعيلها.';
          openSettings = () => LocationService.openLocationSettings();
        } else if (e == LocationErrors.permissionDenied) {
          message = 'تم رفض إذن الموقع. يمكنك إعادة المحاولة.';
        } else if (e == LocationErrors.permissionDeniedForever) {
          message = 'تم رفض إذن الموقع نهائيًا. فعّله من إعدادات التطبيق.';
          openSettings = () => LocationService.openAppSettings();
        }

        final retry = await _showRetryDialog(message, onSettings: openSettings);
        if (!retry) return false;
      }
    }
    return false;
  }

  Future<void> _loadBranchesForManualSelection({
    required bool selectAfterLoad,
  }) async {
    await ref.read(branchVmProvider.notifier).getBranches();
    if (!mounted) return;
    
    final sessionBranch = await ref.read(sessionManagerProvider).getBranchName();
    final state = ref.read(branchVmProvider);
    
    if (state is BranchLoaded && state.branches.isNotEmpty && sessionBranch == null) {
      final mainBranch = state.branches.firstWhere((b) => b.isMain, orElse: () => state.branches.first);
      await _selectBranch(mainBranch);
    }

    if (!selectAfterLoad) return;
    if (state is! BranchLoaded) return;

    final selected = await showDialog<BranchModel>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('اختيار الفرع'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: state.branches.length,
            separatorBuilder: (_, __) => const Divider(height: 12),
            itemBuilder: (context, index) {
              final branch = state.branches[index];
              return ListTile(
                dense: true,
                title: Text(branch.nameAr),
                subtitle: branch.addressAr != null
                    ? Text(branch.addressAr!)
                    : null,
                onTap: () => AppNavigator.pop(context, branch),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => AppNavigator.pop(context),
            child: const Text('تخطي'),
          ),
        ],
      ),
    );

    if (selected != null) {
      await _selectBranch(selected);
    }
  }

  Future<bool> _autoSelectNearestBranch({
    required double lat,
    required double lng,
  }) async {
    final state = ref.read(branchVmProvider);
    if (state is! BranchLoaded || state.branches.isEmpty) return false;

    BranchModel? nearest;
    double minDistance = double.infinity;
    for (final branch in state.branches) {
      if (branch.latitude == null || branch.longitude == null) continue;
      final d = Geolocator.distanceBetween(
        lat,
        lng,
        branch.latitude!,
        branch.longitude!,
      );
      if (d < minDistance) {
        minDistance = d;
        nearest = branch;
      }
    }

    if (nearest == null) {
      final first = state.branches.first;
      await _selectBranch(first);
      return true;
    }
    await _selectBranch(nearest);
    return true;
  }

  Future<void> _selectBranch(BranchModel branch) async {
    await ref.read(sessionManagerProvider).setBranchId(branch.id);
    await ref.read(sessionManagerProvider).setBranchName(branch.nameAr);
    ref.read(locationProvider.notifier).updateSelectedBranch(branch.nameAr);
    await ref
        .read(branchVmProvider.notifier)
        .updateBranch(branch.id.toString());
  }

  Future<_LocationStartAction> _showLocationChoiceDialog() async {
    return await showDialog<_LocationStartAction>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('خدمات الموقع'),
            content: const Text(
              'فعّل الموقع لاقتراح أقرب فرع لك، أو اختر الفرع يدويًا.',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    AppNavigator.pop(context, _LocationStartAction.skip),
                child: const Text('تخطي'),
              ),
              TextButton(
                onPressed: () => AppNavigator.pop(
                  context,
                  _LocationStartAction.manualSelect,
                ),
                child: const Text('اختيار يدوي'),
              ),
              ElevatedButton(
                onPressed: () => AppNavigator.pop(
                  context,
                  _LocationStartAction.enableLocation,
                ),
                child: const Text('تفعيل الموقع'),
              ),
            ],
          ),
        ) ??
        _LocationStartAction.skip;
  }

  Future<bool> _showRetryDialog(
    String message, {
    VoidCallback? onSettings,
  }) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('تنبيه الموقع'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => AppNavigator.pop(context, false),
                child: const Text('تخطي'),
              ),
              if (onSettings != null)
                TextButton(
                  onPressed: onSettings,
                  child: const Text('الإعدادات'),
                ),
              ElevatedButton(
                onPressed: () => AppNavigator.pop(context, true),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

enum _LocationStartAction { enableLocation, manualSelect, skip }
