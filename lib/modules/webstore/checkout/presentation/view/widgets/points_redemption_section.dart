import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/modules/webstore/points/presentation/view_model/points_providers.dart';
import 'package:erp/modules/webstore/points/data/models/points_model.dart';
import 'points_redemption_widgets/points_redemption_section_header.dart';
import 'points_redemption_widgets/points_redemption_section_balance_card.dart';
import 'points_redemption_widgets/points_redemption_section_points_selector.dart';
import 'points_redemption_widgets/points_redemption_section_preview_card.dart';
import 'points_redemption_widgets/points_redemption_section_apply_button.dart';
import 'points_redemption_widgets/points_redemption_section_applied_state.dart';
import 'points_redemption_widgets/points_redemption_section_state_logic.dart';

class PointsRedemptionSection extends ConsumerStatefulWidget {
  final int? addressId;
  final int? paymentMethodId;
  final String? couponCode;
  const PointsRedemptionSection({super.key, this.addressId, this.paymentMethodId, this.couponCode});

  @override
  ConsumerState<PointsRedemptionSection> createState() => _PointsRedemptionSectionState();
}

class _PointsRedemptionSectionState extends ConsumerState<PointsRedemptionSection> {
  double _sliderValue = 0;
  int _appliedPoints = 0;
  bool _isPreviewLoading = false;
  double? _previewDiscount;
  String? _previewError;
  Timer? _debounce;
  int _cachedMaxPoints = 0;

  int get _selectedPoints => _sliderValue.round();
  bool get _isApplied => _appliedPoints > 0;
  int get _maxPoints => _cachedMaxPoints;

  @override
  void dispose() { _debounce?.cancel(); super.dispose(); }

  void _onSliderChanged(double value) {
    setState(() { _sliderValue = value.clamp(0, _maxPoints.toDouble()); _previewDiscount = null; _previewError = null; _isPreviewLoading = true; });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _callPreview);
  }

  void _onQuickSelect(double fraction) {
    final pts = (_maxPoints * fraction).round().clamp(0, _maxPoints);
    setState(() { _sliderValue = pts.toDouble(); _previewDiscount = null; _previewError = null; });
    _callPreview();
  }

  Future<void> _callPreview() async {
    final pts = _selectedPoints;
    if (pts <= 0) return;
    setState(() => _isPreviewLoading = true);
    final discount = await PointsRedemptionSectionLogic.previewLoyalty(pts, ref);
    if (!mounted) return;
    setState(() { _isPreviewLoading = false; _previewDiscount = discount; _previewError = discount == null ? 'حدث خطأ في المعاينة' : null; });
  }

  void _applyPoints() {
    final pts = _selectedPoints;
    if (pts <= 0) return;
    setState(() => _appliedPoints = pts);
    PointsRedemptionSectionLogic.applyPoints(pts, ref, addressId: widget.addressId, paymentMethodId: widget.paymentMethodId, couponCode: widget.couponCode);
  }

  void _cancelPoints() {
    setState(() { _sliderValue = 0; _appliedPoints = 0; _previewDiscount = null; _previewError = null; });
    PointsRedemptionSectionLogic.cancelPoints(ref, addressId: widget.addressId, paymentMethodId: widget.paymentMethodId, couponCode: widget.couponCode);
  }

  @override
  Widget build(BuildContext context) {
    final pointsAsync = ref.watch(pointsProvider);
    const _useMock = true;

    return pointsAsync.when(
      loading: () => AppCard(padding: EdgeInsets.all(20.w), child: const PointsRedemptionSectionHeader(loading: true)),
      error: (err, _) => AppCard(
        padding: EdgeInsets.all(20.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const PointsRedemptionSectionHeader(),
          12.verticalSpace,
          Row(children: [
            Icon(Icons.error_outline_rounded, size: 16.sp, color: Colors.red),
            8.horizontalSpace,
            Text('تعذر تحميل النقاط', style: TextStyle(fontSize: 13.sp, color: Colors.red.shade600)),
          ]),
        ]),
      ),
      data: (rawData) {
        final pointsData = _useMock
            ? PointsModel(balance: 1250, monetaryValue: 12.50, transactions: const [])
            : rawData;
        final maxPoints = pointsData.balance;
        _cachedMaxPoints = maxPoints;
        if (_sliderValue > maxPoints) _sliderValue = maxPoints.toDouble();

        return AppCard(
          padding: EdgeInsets.all(20.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PointsRedemptionSectionHeader(),
            16.verticalSpace,
            PointsRedemptionSectionBalanceCard(balance: pointsData.balance, monetaryValue: pointsData.monetaryValue),
            if (maxPoints > 0) ...[
              20.verticalSpace,
              if (!_isApplied) PointsRedemptionSectionPointsSelector(
                selectedPoints: _selectedPoints, maxPoints: maxPoints,
                onSliderChanged: _onSliderChanged, onQuickSelect: _onQuickSelect,
              ),
              if (!_isApplied && _selectedPoints > 0) ...[
                16.verticalSpace,
                PointsRedemptionSectionPreviewCard(
                  isPreviewLoading: _isPreviewLoading, previewError: _previewError, previewDiscount: _previewDiscount,
                ),
                16.verticalSpace,
                PointsRedemptionSectionApplyButton(
                  selectedPoints: _selectedPoints, isPreviewLoading: _isPreviewLoading, onApply: _applyPoints,
                ),
              ],
              if (_isApplied) PointsRedemptionSectionAppliedState(appliedPoints: _appliedPoints, onCancel: _cancelPoints),
            ],
          ]),
        );
      },
    );
  }
}
