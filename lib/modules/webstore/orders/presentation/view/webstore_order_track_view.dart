import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/constants/app_constants.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/orders/presentation/view_model/orders_providers.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:intl/intl.dart';

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
      appBar: const CommonAppBar(titleText: 'Order Tracking'),
      body: trackingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(
          child: AppErrorWidget(
            errorMessage: err.toString(),
            onRetry: () => ref.refresh(orderTrackingProvider(orderId)),
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
          final total = (data['total'] ?? data['total_amount'] ?? '0.00').toString();
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
                            Text('Order ID: $orderNumber',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w800)),
                            4.verticalSpace,
                            Text(
                                DateFormat('MMM d, yyyy \'at\' h:mm a')
                                    .format(createdAt ?? DateTime.now()),
                                style: TextStyle(
                                    fontSize: 12.sp, color: theme.hintColor)),
                          ],
                        ),
                        Text(
                          '\$$total',
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryOrange),
                        ),
                      ],
                    ),
                  ),
                ),
                
                24.verticalSpace,

                // ─── Map Placeholder ───────────────────────
                AppAnimation.fadeInUp(
                  child: Container(
                    height: 180.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=800&auto=format&fit=crop'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_bike_rounded, color: AppColors.primaryOrange, size: 20.sp),
                            8.horizontalSpace,
                            Text('Arriving in 15 mins', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                24.verticalSpace,

                // ─── Delivery Timeline ────────────────────
                AppCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                       _buildTimelineStep(
                        context,
                        title: 'Order Placed',
                        subtitle: 'Your order has been received.',
                        time: DateFormat('h:mm a').format(createdAt ?? DateTime.now()),
                        isActive: true,
                        isCompleted: true,
                      ),
                       _buildTimelineStep(
                        context,
                        title: 'Processing',
                        subtitle: 'Order is being prepared.',
                        time: '--:--',
                        isActive: status == 'processing' || status == 'shipped' || status == 'delivered',
                        isCompleted: status == 'shipped' || status == 'delivered',
                      ),
                       _buildTimelineStep(
                        context,
                        title: 'Out for Delivery',
                        subtitle: 'Courier is on the way.',
                        time: '--:--',
                        isActive: status == 'shipped' || status == 'delivered',
                        isCompleted: status == 'delivered',
                        isLast: false,
                      ),
                       _buildTimelineStep(
                        context,
                        title: 'Delivered',
                        subtitle: 'Order successfully delivered.',
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
                      CircleAvatar(
                        radius: 24.r,
                        backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=200&auto=format&fit=crop'),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ahmed Mohamed', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                            Text('Delivery Partner', style: TextStyle(fontSize: 12.sp, color: theme.hintColor)),
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
                  onPressed: () => AppNavigator.push(context, AppRouteNames.webstoreRateOrder),
                  isGradient: true,
                  child: Text(
                    'Rate Your Order',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _buildTimelineStep(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String time,
    required bool isActive,
    required bool isCompleted,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppColors.primaryOrange : (isActive ? Colors.white : Colors.grey[300]),
                  border: Border.all(
                    color: isCompleted ? AppColors.primaryOrange : (isActive ? AppColors.primaryOrange : Colors.grey[400]!),
                    width: 2,
                  ),
                ),
                child: isCompleted 
                  ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                  : (isActive ? Center(child: Container(width: 8.w, height: 8.w, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryOrange))) : null),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? AppColors.primaryOrange : Colors.grey[300],
                  ),
                ),
            ],
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                        color: isActive ? null : theme.hintColor,
                      ),
                    ),
                    Text(time, style: TextStyle(fontSize: 11.sp, color: theme.hintColor)),
                  ],
                ),
                4.verticalSpace,
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                ),
                if (!isLast) 24.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, {bool isGreen = false}) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: (isGreen ? Colors.green : AppColors.primaryOrange).withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: isGreen ? Colors.green : AppColors.primaryOrange, size: 20.sp),
    );
  }
}
