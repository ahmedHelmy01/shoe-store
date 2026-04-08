import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';

class WebStoreOrderListView extends StatelessWidget {
  const WebStoreOrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Mock data for UI demonstration
    final List<Map<String, dynamic>> orders = [
      {
        'id': '#ORD-12345',
        'date': 'Oct 24, 2023',
        'status': 'webstore.orders.status_processing',
        'color': AppColors.warning,
        'items': 3,
        'total': '450.00',
        'images': [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=200&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200&auto=format&fit=crop',
        ]
      },
      {
        'id': '#ORD-12344',
        'date': 'Oct 20, 2023',
        'status': 'webstore.orders.status_shipped',
        'color': AppColors.info,
        'items': 1,
        'total': '120.00',
        'images': [
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=200&auto=format&fit=crop',
        ]
      },
      {
        'id': '#ORD-12340',
        'date': 'Oct 15, 2023',
        'status': 'webstore.orders.status_delivered',
        'color': AppColors.success,
        'items': 5,
        'total': '890.00',
        'images': [
          'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?q=80&w=200&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=200&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200&auto=format&fit=crop',
        ]
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(titleText: 'webstore.orders.title'.tr()),
      body: ListView.separated(
        padding: EdgeInsets.all(20.w),
        itemCount: orders.length,
        separatorBuilder: (context, index) => 16.verticalSpace,
        itemBuilder: (context, index) {
          final order = orders[index];
          return AppAnimation.fadeInUp(
            delay: Duration(milliseconds: index * 100),
            child: GestureDetector(
              onTap: () {
                AppNavigator.push(context, AppRouteNames.webstoreOrderDetails);
              },
              child: AppCard(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Order ID & Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order['id'],
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        order['date'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  
                  // Status & Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: (order['color'] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          (order['status'] as String).tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: order['color'],
                          ),
                        ),
                      ),
                      Text(
                        '\$${order['total']}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                  
                  16.verticalSpace,
                  Divider(color: theme.dividerColor.withValues(alpha: 0.5)),
                  10.verticalSpace,
                  
                  // Images row showing items
                  Row(
                    children: [
                      ...((order['images'] as List<String>).take(3).map((img) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(img, width: 48.w, height: 48.w, fit: BoxFit.cover),
                          ),
                        );
                      })),
                      if ((order['items'] as int) > 3)
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '+${(order['items'] as int) - 3}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                        ),
                      const Spacer(),
                      
                      // Details Arrow
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                        ),
                        child: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ),
          );
        },
      ),
    );
  }
}
