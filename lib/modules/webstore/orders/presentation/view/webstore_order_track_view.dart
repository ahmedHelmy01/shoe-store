import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trackingAsync = ref.watch(orderTrackingProvider(orderId));

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
          Map<String, dynamic> data = {};
          List<dynamic> timeline = [];

          if (trackingData is Map) {
            final rawData = trackingData['data'] ?? trackingData;
            if (rawData is Map<String, dynamic>) {
              data = rawData;
              // If the map contains a list of tracking events
              if (data['tracking'] is List) {
                timeline = data['tracking'];
              } else if (data['history'] is List) {
                timeline = data['history'];
              }
            } else if (rawData is List) {
              timeline = rawData;
              if (timeline.isNotEmpty && timeline.first is Map) {
                data = Map<String, dynamic>.from(timeline.first);
              }
            }
          } else if (trackingData is List) {
            timeline = trackingData;
            if (timeline.isNotEmpty && timeline.first is Map) {
              data = Map<String, dynamic>.from(timeline.first);
            }
          }

          final status = (data['status'] ?? data['order_status'] ?? '')
              .toString()
              .toLowerCase();
          final total = (data['total'] ?? data['total_amount'] ?? '0.00')
              .toString();
          final createdAt = data['created_at'] != null
              ? DateTime.tryParse(data['created_at'].toString())
              : DateTime.now();

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // ─── Order Summary Card ────────────────────
                AppAnimation.fadeInDown(
                  child: AppCard(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.webstore.orders.order_id.tr(
                                context: context,
                                args: [orderNumber],
                              ),
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              DateFormat(
                                'MMM d, yyyy \'at\' h:mm a',
                              ).format(createdAt ?? DateTime.now()),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '$total ${AppConstants.currency}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                24.verticalSpace,

                // ─── Map Placeholder ───────────────────────
                AppAnimation.fadeInUp(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: AppImage(
                            imagePath:
                                'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=800&auto=format&fit=crop',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.directions_bike_rounded,
                                  color: AppColors.primaryOrange,
                                  size: 20.sp,
                                ),
                                8.horizontalSpace,
                                Text(
                                  LocaleKeys.webstore.orders.arriving_in.tr(
                                    context: context,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                24.verticalSpace,

                // ─── Delivery Timeline ────────────────────
                AppCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      WebStoreOrderTrackTimelineStepWidget(
                        title: LocaleKeys.webstore.orders.order_placed.tr(
                          context: context,
                        ),
                        subtitle: LocaleKeys
                            .webstore
                            .orders
                            .order_placed_subtitle
                            .tr(context: context),
                        time: DateFormat(
                          'h:mm a',
                        ).format(createdAt ?? DateTime.now()),
                        isActive: true,
                        isCompleted: true,
                      ),
                      WebStoreOrderTrackTimelineStepWidget(
                        title: LocaleKeys.webstore.orders.status_processing.tr(
                          context: context,
                        ),
                        subtitle: LocaleKeys.webstore.orders.processing_subtitle
                            .tr(context: context),
                        time: '--:--',
                        isActive:
                            status == 'processing' ||
                            status == 'shipped' ||
                            status == 'delivered',
                        isCompleted:
                            status == 'shipped' || status == 'delivered',
                      ),
                      WebStoreOrderTrackTimelineStepWidget(
                        title: LocaleKeys.webstore.orders.out_for_delivery.tr(
                          context: context,
                        ),
                        subtitle: LocaleKeys
                            .webstore
                            .orders
                            .out_for_delivery_subtitle
                            .tr(context: context),
                        time: '--:--',
                        isActive: status == 'shipped' || status == 'delivered',
                        isCompleted: status == 'delivered',
                      ),
                      WebStoreOrderTrackTimelineStepWidget(
                        title: LocaleKeys.webstore.orders.status_delivered.tr(
                          context: context,
                        ),
                        subtitle: LocaleKeys.webstore.orders.delivered_subtitle
                            .tr(context: context),
                        time: '--:--',
                        isActive: status == 'delivered',
                        isCompleted: status == 'delivered',
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                24.verticalSpace,

                // ─── Courier Details ───────────────────────
                AppCard(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 48.r,
                          height: 48.r,
                          child: AppImage(
                            imagePath:
                                'https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=200&auto=format&fit=crop',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ahmed Mohamed',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              LocaleKeys.webstore.orders.delivery_partner.tr(
                                context: context,
                              ),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _iconBtn(Icons.call_rounded, isGreen: true),
                          8.horizontalSpace,
                          _iconBtn(Icons.chat_bubble_outline_rounded),
                        ],
                      ),
                    ],
                  ),
                ),

                32.verticalSpace,

                // Rate Order Button
                AppButton(
                  onPressed: () => AppNavigator.push(
                    context,
                    AppRouteNames.webstoreRateOrder,
                    arguments: {'order_id': orderId},
                  ),
                  isGradient: true,
                  child: Text(
                    LocaleKeys.webstore.orders.rate_order.tr(context: context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _iconBtn(IconData icon, {bool isGreen = false}) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: (isGreen ? Colors.green : AppColors.primaryOrange).withValues(
          alpha: 0.1,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isGreen ? Colors.green : AppColors.primaryOrange,
        size: 20.sp,
      ),
    );
  }
}
