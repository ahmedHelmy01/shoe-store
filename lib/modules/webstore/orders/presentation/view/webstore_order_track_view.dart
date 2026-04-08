import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/constants/app_constants.dart';

class WebStoreOrderTrackView extends StatelessWidget {
  const WebStoreOrderTrackView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CommonAppBar(titleText: 'Order Tracking'),
      body: SingleChildScrollView(
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
                        Text('Order ID: #87922', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800)),
                        4.verticalSpace,
                        Text('Sept 12, 2024 at 10:45 AM', style: TextStyle(fontSize: 12.sp, color: theme.hintColor)),
                      ],
                    ),
                    Text(
                      '\$423.00',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.primaryOrange),
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
                    time: '10:45 AM',
                    isActive: true,
                    isCompleted: true,
                  ),
                   _buildTimelineStep(
                    context,
                    title: 'Processing',
                    subtitle: 'Order is being prepared.',
                    time: '11:02 AM',
                    isActive: true,
                    isCompleted: true,
                  ),
                   _buildTimelineStep(
                    context,
                    title: 'Out for Delivery',
                    subtitle: 'Courier is on the way.',
                    time: '11:30 AM',
                    isActive: true,
                    isCompleted: false,
                    isLast: false,
                  ),
                   _buildTimelineStep(
                    context,
                    title: 'Delivered',
                    subtitle: 'Order successfully delivered.',
                    time: '--:--',
                    isActive: false,
                    isCompleted: false,
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
