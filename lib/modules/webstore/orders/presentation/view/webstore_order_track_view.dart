import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/orders/presentation/view_model/orders_providers.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:erp/modules/webstore/orders/presentation/view/widgets/webstore_order_track_timeline_step.dart';

class WebStoreOrderTrackView extends ConsumerWidget {
  final int orderId;
  final String orderNumber;

  const WebStoreOrderTrackView({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  Color _parseColor(String? hexString, {Color defaultColor = Colors.grey}) {
    if (hexString == null || hexString.isEmpty) return defaultColor;
    try {
      final hex = hexString.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return defaultColor;
  }

  String _formatStepDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final stepDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (today == stepDay) {
      return DateFormat('h:mm a').format(dateTime);
    } else {
      return DateFormat('MMM d, h:mm a').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trackingAsync = ref.watch(orderTrackingProvider(orderId));
    final emptyMessage = LocaleKeys.webstore.orders.no_tracking_updates.tr(context: context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        titleText: LocaleKeys.webstore.orders.order_tracking.tr(
          context: context,
        ),
      ),
      body: trackingAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(
          child: AppErrorWidget(
            errorMessage: err.toString(),
            onRetry: () => ref.invalidate(orderTrackingProvider(orderId)),
          ),
        ),
        data: (trackingData) {
          // Handle both Map (with 'data' wrapper) and List responses
          List<dynamic> timeline = [];

          if (trackingData is Map) {
            final rawData = trackingData['data'] ?? trackingData;
            if (rawData is List) {
              timeline = rawData;
            } else if (rawData is Map<String, dynamic>) {
              if (rawData['tracking'] is List) {
                timeline = rawData['tracking'];
              } else if (rawData['history'] is List) {
                timeline = rawData['history'];
              }
            }
          } else if (trackingData is List) {
            timeline = trackingData;
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        // ─── Header Info Card ───────────────────
                        AppAnimation.fadeInDown(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primaryOrange,
                                  AppColors.orange,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryOrange.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            LocaleKeys.webstore.orders.order_id.tr(
                                              context: context,
                                              args: [orderNumber],
                                            ),
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (timeline.isNotEmpty) ...[
                                            6.verticalSpace,
                                            Text(
                                              _formatStepDate(
                                                DateTime.tryParse(
                                                  timeline.first['date']?.toString() ?? ''
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.white.withValues(alpha: 0.85),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    if (timeline.isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(30.r),
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.4),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 8.r,
                                              height: 8.r,
                                              decoration: BoxDecoration(
                                                color: _parseColor(
                                                  timeline.first['color']?.toString()
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            8.horizontalSpace,
                                            Text(
                                              timeline.first['status']?.toString() ?? '',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        24.verticalSpace,

                        // ─── Dynamic Delivery Timeline Card ────
                        if (timeline.isEmpty)
                          AppAnimation.fadeInUp(
                            child: AppCard(
                              padding: EdgeInsets.symmetric(
                                vertical: 40.h,
                                horizontal: 20.w,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_shipping_outlined,
                                    size: 70.sp,
                                    color: theme.hintColor.withValues(alpha: 0.5),
                                  ),
                                  16.verticalSpace,
                                  Text(
                                    emptyMessage,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: theme.hintColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          AppAnimation.fadeInUp(
                            child: AppCard(
                              padding: EdgeInsets.all(20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LocaleKeys.webstore.orders.shipping_status_updates.tr(context: context),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  20.verticalSpace,
                                  Column(
                                    children: List.generate(
                                      timeline.length,
                                      (index) {
                                        final step = timeline[index];
                                        final stepStatus =
                                            step['status']?.toString() ?? '';
                                        final stepNotes =
                                            step['notes']?.toString() ?? '';
                                        final stepColor = _parseColor(
                                          step['color']?.toString()
                                        );
                                        final stepDate = step['date'] != null
                                            ? DateTime.tryParse(
                                                step['date'].toString()
                                              )
                                            : null;
                                        final timeStr = _formatStepDate(stepDate);

                                        final isFirst = index == 0;
                                        final isLast = index == timeline.length - 1;

                                        return WebStoreOrderTrackTimelineStepWidget(
                                          title: stepStatus,
                                          subtitle: stepNotes,
                                          time: timeStr,
                                          isActive: isFirst,
                                          isCompleted: true,
                                          isLast: isLast,
                                          indicatorColor: stepColor,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ),

                // ─── Pinned Bottom Buttons ────────────────
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        onPressed: () => AppNavigator.push(
                          context,
                          AppRouteNames.webstoreRateOrder,
                          arguments: {'order_id': orderId},
                        ),
                        isGradient: true,
                        child: Text(
                          LocaleKeys.webstore.orders.rate_order.tr(
                            context: context,
                          ),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      12.verticalSpace,
                      AppButton(
                        type: ButtonType.outline,
                        onPressed: () => AppNavigator.pushAndRemoveUntil(
                          context,
                          AppRouteNames.webstoreMain,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_outlined,
                              size: 20.sp,
                              color: AppColors.primaryOrange,
                            ),
                            8.horizontalSpace,
                            Text(
                              LocaleKeys.webstore.checkout.back_to_home.tr(
                                context: context,
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
