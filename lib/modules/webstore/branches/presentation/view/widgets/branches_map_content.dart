import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';
import 'package:erp/modules/webstore/branches/presentation/view/widgets/branch_info_card.dart';
import 'package:erp/modules/webstore/branches/presentation/view/widgets/branch_marker_widget.dart';
import 'package:erp/modules/webstore/branches/presentation/view/widgets/nearest_branches_loading_card.dart';
import 'package:erp/modules/webstore/branches/presentation/view/widgets/nearest_branches_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class BranchesMapContent extends StatelessWidget {
  final MapController mapController;
  final LatLng initialCenter;
  final List<BranchModel> mapBranches;
  final LatLng? userLocation;
  final BranchModel? selectedBranch;
  final List<BranchModel> nearestBranches;
  final Map<int, double> distanceByBranchId;
  final bool isFindingNearest;
  final VoidCallback onPressNearest;
  final ValueChanged<BranchModel> onTapBranch;
  final BranchModel? routeBranch;
  final ValueChanged<BranchModel>? onTapDirections;

  const BranchesMapContent({
    super.key,
    required this.mapController,
    required this.initialCenter,
    required this.mapBranches,
    required this.userLocation,
    required this.selectedBranch,
    required this.nearestBranches,
    required this.distanceByBranchId,
    required this.isFindingNearest,
    required this.onPressNearest,
    required this.onTapBranch,
    required this.routeBranch,
    this.onTapDirections,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final nearestList = nearestBranches.take(3).toList();
    final hasBottomPanel =
        isFindingNearest ||
        selectedBranch != null ||
        (userLocation != null && nearestList.isNotEmpty);

    return Stack(
      children: [
        RepaintBoundary(
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 12.5,
              interactionOptions: const InteractionOptions(
                flags:
                    InteractiveFlag.drag |
                    InteractiveFlag.pinchZoom |
                    InteractiveFlag.doubleTapZoom,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.erp.webstore',
              ),
              if (userLocation != null && routeBranch != null)
                PolylineLayer(
                  polylines: _buildDashedRoute(
                    from: userLocation!,
                    to: LatLng(routeBranch!.latitude!, routeBranch!.longitude!),
                    isDark: isDark,
                  ),
                ),
              MarkerLayer(
                markers: [
                  ...mapBranches.map((branch) {
                    final isSelected = selectedBranch?.id == branch.id;
                    return Marker(
                      point: LatLng(branch.latitude!, branch.longitude!),
                      width: 52.w,
                      height: 66.h,
                      child: GestureDetector(
                        onTap: () => onTapBranch(branch),
                        child: BranchMarkerWidget(isSelected: isSelected),
                      ),
                    );
                  }),
                  if (userLocation != null)
                    Marker(
                      point: userLocation!,
                      width: 26.w,
                      height: 26.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        PositionedDirectional(
          end: 12.w,
          bottom: _fabBottomOffset(hasBottomPanel: hasBottomPanel),
          child: FloatingActionButton.small(
            heroTag: 'nearest-branch-fab',
            backgroundColor: Colors.white,
            onPressed: isFindingNearest ? null : onPressNearest,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: isFindingNearest
                  ? SizedBox(
                      key: const ValueKey('loading'),
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.primaryOrange,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.near_me_rounded,
                      key: ValueKey('icon'),
                      color: AppColors.primaryOrange,
                    ),
            ),
          ),
        ),
        Positioned(
          left: 12.w,
          right: 12.w,
          bottom: 16.h,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: isFindingNearest
                ? const NearestBranchesLoadingCard(
                    key: ValueKey('nearest-loading'),
                  )
                : (selectedBranch != null)
                ? BranchInfoCard(
                    key: const ValueKey('branch-card'),
                    branch: selectedBranch!,
                    distanceMeters: distanceByBranchId[selectedBranch!.id],
                    onTapDirections: onTapDirections == null
                        ? null
                        : () => onTapDirections!(selectedBranch!),
                  )
                : (userLocation != null && nearestList.isNotEmpty)
                ? NearestBranchesPanel(
                    key: const ValueKey('nearest-panel'),
                    nearestBranches: nearestList,
                    distanceByBranchId: distanceByBranchId,
                    onTapBranch: onTapBranch,
                    onTapDirections: onTapDirections,
                  )
                : const SizedBox.shrink(key: ValueKey('panel-empty')),
          ),
        ),
      ],
    );
  }

  List<Polyline> _buildDashedRoute({
    required LatLng from,
    required LatLng to,
    required bool isDark,
  }) {
    // Simple dashed line by splitting into short segments.
    const dashMeters = 22.0;
    const gapMeters = 14.0;
    const stroke = 3.6;
    const shadowStroke = 6.5;

    final total = _haversineMeters(from, to);
    if (total <= 0) return const [];

    final dirLat = to.latitude - from.latitude;
    final dirLng = to.longitude - from.longitude;
    final stepCount = (total / (dashMeters + gapMeters)).ceil().clamp(1, 300);

    final polylines = <Polyline>[];
    double traveled = 0;
    for (int i = 0; i < stepCount; i++) {
      final startFrac = traveled / total;
      final endFrac = math.min((traveled + dashMeters) / total, 1.0);
      final start = LatLng(
        from.latitude + dirLat * startFrac,
        from.longitude + dirLng * startFrac,
      );
      final end = LatLng(
        from.latitude + dirLat * endFrac,
        from.longitude + dirLng * endFrac,
      );

      // soft shadow behind (looks nicer on both light/dark)
      polylines.add(
        Polyline(
          points: [start, end],
          strokeWidth: shadowStroke,
          color: isDark
              ? Colors.black.withValues(alpha: 0.20)
              : Colors.white.withValues(alpha: 0.80),
        ),
      );
      // main dashed stroke
      polylines.add(
        Polyline(
          points: [start, end],
          strokeWidth: stroke,
          color: AppColors.primaryOrange,
        ),
      );
      traveled += dashMeters + gapMeters;
      if (traveled >= total) break;
    }
    return polylines;
  }

  double _haversineMeters(LatLng a, LatLng b) {
    const r = 6371000.0;
    final dLat = _degToRad(b.latitude - a.latitude);
    final dLon = _degToRad(b.longitude - a.longitude);
    final lat1 = _degToRad(a.latitude);
    final lat2 = _degToRad(b.latitude);
    final sinDLat = math.sin(dLat / 2);
    final sinDLon = math.sin(dLon / 2);
    final h =
        sinDLat * sinDLat + math.cos(lat1) * math.cos(lat2) * sinDLon * sinDLon;
    return 2 * r * math.asin(math.min(1, math.sqrt(h)));
  }

  double _degToRad(double deg) => deg * (math.pi / 180.0);

  double _fabBottomOffset({required bool hasBottomPanel}) {
    if (hasBottomPanel) return 240.h;
    return 24.h;
  }
}
