import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/services/location_service.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';
import 'package:erp/modules/webstore/branches/presentation/state/branch_state.dart';
import 'package:erp/modules/webstore/branches/presentation/view_model/branch_view_model.dart';
import 'package:erp/modules/webstore/branches/presentation/view/widgets/branches_map_content.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:async';

class BranchesMapView extends ConsumerStatefulWidget {
  const BranchesMapView({super.key});

  @override
  ConsumerState<BranchesMapView> createState() => _BranchesMapViewState();
}

class _BranchesMapViewState extends ConsumerState<BranchesMapView> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  int? _selectedBranchId;
  int? _routeBranchId;
  Map<int, double> _distanceByBranchId = {};
  bool _isFindingNearest = false;
  StreamSubscription<Position>? _positionSub;

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branchState = ref.watch(branchVmProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CommonAppBar(
        titleText: 'فروعنا',
        backgroundColor: isDark ? const Color(0xFF0B1220) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        showBackButton: true,
      ),
      body: branchState is BranchLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : branchState is BranchError
          ? Center(
              child: AppErrorWidget(
                errorMessage: branchState.message,
                onRetry: () => ref.read(branchVmProvider.notifier).getBranches(),
              ),
            )
          : branchState is BranchLoaded
          ? _buildMapContent(branchState.branches)
          : const SizedBox.shrink(),
    );
  }

  Widget _buildMapContent(List<BranchModel> branches) {
    final mapBranches = branches
        .where((b) => b.latitude != null && b.longitude != null)
        .toList();

    if (mapBranches.isEmpty) {
      return const Center(
        child: Text('لا توجد فروع تحتوي على إحداثيات حالياً'),
      );
    }

    final initial = LatLng(
      mapBranches.first.latitude!,
      mapBranches.first.longitude!,
    );
    BranchModel? selectedBranch;
    for (final branch in mapBranches) {
      if (branch.id == _selectedBranchId) {
        selectedBranch = branch;
        break;
      }
    }
    BranchModel? routeBranch;
    for (final branch in mapBranches) {
      if (branch.id == _routeBranchId) {
        routeBranch = branch;
        break;
      }
    }

    final nearestBranches = _sortedByDistance(mapBranches);

    return BranchesMapContent(
      mapController: _mapController,
      initialCenter: initial,
      mapBranches: mapBranches,
      userLocation: _userLocation,
      selectedBranch: selectedBranch,
      routeBranch: routeBranch,
      nearestBranches: nearestBranches,
      distanceByBranchId: _distanceByBranchId,
      isFindingNearest: _isFindingNearest,
      onPressNearest: () => _goToNearestBranch(mapBranches),
      onTapBranch: (branch) {
        setState(() => _selectedBranchId = branch.id);
        _mapController.move(LatLng(branch.latitude!, branch.longitude!), 14.5);
      },
      onTapDirections: (branch) => _startRouteToBranch(branch, mapBranches),
    );
  }

  Future<void> _startRouteToBranch(
    BranchModel branch,
    List<BranchModel> allBranches,
  ) async {
    // Ensure we have user location first
    if (_userLocation == null) {
      await _goToNearestBranch(allBranches);
      if (_userLocation == null) return;
    }

    setState(() {
      _routeBranchId = branch.id;
      _selectedBranchId = branch.id;
    });
    _mapController.move(LatLng(branch.latitude!, branch.longitude!), 14.5);

    await _positionSub?.cancel();
    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 10,
          ),
        ).listen((pos) {
          final user = LatLng(pos.latitude, pos.longitude);
          if (!mounted) return;
          setState(() {
            _userLocation = user;
            _distanceByBranchId = _computeDistances(user, allBranches);
          });
        });
  }

  Map<int, double> _computeDistances(LatLng user, List<BranchModel> branches) {
    final map = <int, double>{};
    for (final b in branches) {
      map[b.id] = Geolocator.distanceBetween(
        user.latitude,
        user.longitude,
        b.latitude!,
        b.longitude!,
      );
    }
    return map;
  }

  Future<void> _goToNearestBranch(List<BranchModel> branches) async {
    if (_isFindingNearest) return;
    setState(() => _isFindingNearest = true);
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جارٍ تحديد أقرب الفروع...')),
      );
    }
    Position? position;
    try {
      position = await LocationService.getCurrentLocation();
    } catch (e) {
      if (mounted) {
        String message = 'يرجى تفعيل الموقع أولاً.';
        if (e == LocationErrors.serviceDisabled) {
          message = 'خدمة GPS متوقفة.';
        } else if (e == LocationErrors.permissionDeniedForever) {
          message = 'إذن الموقع مرفوض نهائيًا. فعّله من الإعدادات.';
        } else if (e == LocationErrors.permissionDenied) {
          message = 'إذن الموقع مرفوض.';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
      if (mounted) setState(() => _isFindingNearest = false);
      return;
    }
    if (position == null) {
      if (mounted) setState(() => _isFindingNearest = false);
      return;
    }
    final user = LatLng(position.latitude, position.longitude);
    _userLocation = user;
    _distanceByBranchId = _computeDistances(user, branches);

    BranchModel? nearest;
    double nearestDistance = double.infinity;
    for (final branch in branches) {
      final distance = _distanceByBranchId[branch.id] ?? double.infinity;
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = branch;
      }
    }

    if (nearest != null) {
      setState(() => _selectedBranchId = nearest!.id);
      _mapController.move(LatLng(nearest.latitude!, nearest.longitude!), 14.5);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('أقرب فرع: ${nearest.nameAr}')));
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    setState(() => _isFindingNearest = false);
  }

  List<BranchModel> _sortedByDistance(List<BranchModel> branches) {
    final sorted = [...branches];
    sorted.sort((a, b) {
      final da = _distanceByBranchId[a.id] ?? double.infinity;
      final db = _distanceByBranchId[b.id] ?? double.infinity;
      return da.compareTo(db);
    });
    return sorted;
  }
}
