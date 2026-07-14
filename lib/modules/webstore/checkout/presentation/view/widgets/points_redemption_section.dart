import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/modules/webstore/checkout/presentation/view_model/checkout_view_model.dart';
import 'package:erp/modules/webstore/points/presentation/view_model/points_providers.dart';
import 'package:erp/modules/webstore/points/data/repositories/points_repository.dart';
import 'package:erp/modules/webstore/points/data/models/points_model.dart';

class PointsRedemptionSection extends ConsumerStatefulWidget {
  final int? addressId;
  final int? paymentMethodId;
  final String? couponCode;

  const PointsRedemptionSection({
    super.key,
    this.addressId,
    this.paymentMethodId,
    this.couponCode,
  });

  @override
  ConsumerState<PointsRedemptionSection> createState() =>
      _PointsRedemptionSectionState();
}

class _PointsRedemptionSectionState
    extends ConsumerState<PointsRedemptionSection> {
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
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value.clamp(0, _maxPoints.toDouble());
      _previewDiscount = null;
      _previewError = null;
      _isPreviewLoading = true;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _previewLoyalty);
  }

  void _onQuickSelect(double fraction) {
    final pts = (_maxPoints * fraction).round().clamp(0, _maxPoints);
    setState(() {
      _sliderValue = pts.toDouble();
      _previewDiscount = null;
      _previewError = null;
    });
    _previewLoyalty();
  }

  Future<void> _previewLoyalty() async {
    final pts = _selectedPoints;
    if (pts <= 0) return;

    setState(() => _isPreviewLoading = true);

    const _useMock = true;

    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() {
        _isPreviewLoading = false;
        _previewDiscount = pts * 0.01; // mock: 1 cent per point
        _previewError = null;
      });
      return;
    }

    try {
      final repo = ref.read(pointsRepositoryProvider);
      final result = await repo.previewLoyalty(pts);
      if (!mounted) return;
      result.when(
        success: (data) {
          setState(() {
            _isPreviewLoading = false;
            _previewDiscount = (data['discount'] as num?)?.toDouble();
            _previewError =
                data['error'] as String? ?? data['message'] as String?;
          });
        },
        failure: (e) {
          setState(() {
            _isPreviewLoading = false;
            _previewError = e.message;
          });
        },
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isPreviewLoading = false;
        _previewError = 'حدث خطأ في المعاينة';
      });
    }
  }

  void _applyPoints() {
    final pts = _selectedPoints;
    if (pts <= 0) return;
    setState(() => _appliedPoints = pts);
    ref
        .read(checkoutVmProvider.notifier)
        .calculateTotals(
          addressId: widget.addressId,
          paymentMethodId: widget.paymentMethodId,
          couponCode: widget.couponCode,
          pointsToRedeem: pts,
        );
  }

  void _cancelPoints() {
    setState(() {
      _sliderValue = 0;
      _appliedPoints = 0;
      _previewDiscount = null;
      _previewError = null;
    });
    ref
        .read(checkoutVmProvider.notifier)
        .calculateTotals(
          addressId: widget.addressId,
          paymentMethodId: widget.paymentMethodId,
          couponCode: widget.couponCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final pointsAsync = ref.watch(pointsProvider);

    const _useMock = true; // ← temporery mock to preview the design

    return pointsAsync.when(
      loading: () => AppCard(
        padding: EdgeInsets.all(20.w),
        child: _buildHeader(theme, loading: true),
      ),
      error: (err, _) => AppCard(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            12.verticalSpace,
            Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 16.sp,
                  color: Colors.red,
                ),
                8.horizontalSpace,
                Text(
                  'تعذر تحميل النقاط',
                  style: TextStyle(fontSize: 13.sp, color: Colors.red.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
      data: (rawData) {
        final pointsData = _useMock
            ? PointsModel(
                balance: 1250,
                monetaryValue: 12.50,
                transactions: const [],
              )
            : rawData;
        final maxPoints = pointsData.balance;
        _cachedMaxPoints = maxPoints;
        if (_sliderValue > maxPoints) {
          _sliderValue = maxPoints.toDouble();
        }

        return AppCard(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              16.verticalSpace,
              _buildBalanceCard(theme, pointsData),
              if (maxPoints > 0) ...[
                20.verticalSpace,
                if (!_isApplied) _buildPointsSelector(theme, maxPoints),
                if (!_isApplied && _selectedPoints > 0) ...[
                  16.verticalSpace,
                  _buildPreviewCard(theme, isDark),
                  16.verticalSpace,
                  _buildApplyButton(theme),
                ],
                if (_isApplied) _buildAppliedState(theme),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, {bool loading = false}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.redeem_rounded,
            color: AppColors.primary,
            size: 20.sp,
          ),
        ),
        12.horizontalSpace,
        Text(
          'نقاطي',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
        if (loading) ...[
          8.horizontalSpace,
          SizedBox(
            width: 14.w,
            height: 14.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBalanceCard(ThemeData theme, dynamic pointsData) {
    final balance = pointsData.balance;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            color: AppColors.primary,
            size: 28.sp,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  balance > 0 ? 'الرصيد المتاح' : 'نقاطي',
                  style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                ),
                Text(
                  balance > 0 ? '$balance نقطة' : 'ليس لديك نقاط حالياً',
                  style: TextStyle(
                    fontSize: balance > 0 ? 18.sp : 14.sp,
                    fontWeight: FontWeight.bold,
                    color: balance > 0 ? null : theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          if (balance > 0 && pointsData.monetaryValue != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '≈',
                  style: TextStyle(color: theme.hintColor, fontSize: 12.sp),
                ),
                Text(
                  '\$${pointsData.monetaryValue!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPointsSelector(ThemeData theme, int maxPoints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'النقاط المستخدمة',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '$_selectedPoints',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        8.verticalSpace,
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.primary.withValues(alpha: 0.15),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.1),
            trackHeight: 6.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: AppColors.primary,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
            ),
          ),
          child: Slider(
            value: _sliderValue.clamp(0, maxPoints.toDouble()),
            min: 0,
            max: maxPoints.toDouble(),
            divisions: maxPoints > 200 ? (maxPoints / 10).round() : maxPoints,
            label: '$_selectedPoints نقطة',
            onChanged: _onSliderChanged,
          ),
        ),
        4.verticalSpace,
        Row(
          children: [
            Text(
              '0',
              style: TextStyle(fontSize: 11.sp, color: theme.hintColor),
            ),
            const Spacer(),
            Text(
              '$maxPoints',
              style: TextStyle(fontSize: 11.sp, color: theme.hintColor),
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          children: [
            _quickBtn('25%', 0.25),
            8.horizontalSpace,
            _quickBtn('50%', 0.50),
            8.horizontalSpace,
            _quickBtn('75%', 0.75),
            8.horizontalSpace,
            _quickBtn('الكل', 1.0),
          ],
        ),
      ],
    );
  }

  Widget _quickBtn(String label, double fraction) {
    final isSelected =
        _selectedPoints ==
            (_maxPoints * fraction).round().clamp(0, _maxPoints) &&
        _selectedPoints > 0;
    return Expanded(
      child: OutlinedButton(
        onPressed: () => _onQuickSelect(fraction),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : null,
          foregroundColor: isSelected ? AppColors.primary : null,
          side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : Theme.of(context).dividerColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildPreviewCard(ThemeData theme, bool isDark) {
    final hasError = _previewError != null && _previewError!.isNotEmpty;
    final hasDiscount = _previewDiscount != null && _previewDiscount! > 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: hasError
            ? Colors.red.withValues(alpha: 0.06)
            : Colors.green.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: hasError
              ? Colors.red.withValues(alpha: 0.2)
              : Colors.green.withValues(alpha: 0.2),
        ),
      ),
      child: _isPreviewLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                8.horizontalSpace,
                Text(
                  'جاري المعاينة...',
                  style: TextStyle(fontSize: 13.sp, color: theme.hintColor),
                ),
              ],
            )
          : hasError
          ? Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 18.sp,
                ),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    _previewError!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            )
          : hasDiscount
          ? Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.local_offer_rounded,
                    color: Colors.green,
                    size: 16.sp,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الخصم المتوقع',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: theme.hintColor,
                        ),
                      ),
                      Text(
                        '-\$${_previewDiscount!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildApplyButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: (_isPreviewLoading || _selectedPoints <= 0)
            ? null
            : _applyPoints,
        icon: Icon(Icons.check_rounded, size: 18.sp),
        label: Text('تطبيق $_selectedPoints نقطة'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: theme.disabledColor,
          disabledForegroundColor: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildAppliedState(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  'تم تطبيق خصم $_appliedPoints نقطة',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        12.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _cancelPoints,
            icon: Icon(Icons.close_rounded, size: 16.sp),
            label: Text('إلغاء خصم النقاط'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red.shade200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
      ],
    );
  }
}
