import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';

class WebStoreNotificationsView extends StatelessWidget {
  const WebStoreNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dummy data for sophisticated UI
    final List<Map<String, dynamic>> dummyNotifications = [
      {
        'id': 1,
        'title': 'تم شحن طلبك! 🚚',
        'body': 'طلبك رقم #12345 في الطريق إليك الآن، استعد لاستلامه.',
        'time': 'منذ 5 دقائق',
        'type': 'order',
        'isRead': false,
      },
      {
        'id': 2,
        'title': 'خصم خاص لك 🎁',
        'body': 'استخدم كود SAVE20 واحصل على خصم 20% على طلبك القادم.',
        'time': 'منذ ساعتين',
        'type': 'discount',
        'isRead': false,
      },
      {
        'id': 3,
        'title': 'نقاط جديدة 🌟',
        'body': 'لقد ربحت 50 نقطة جديدة من عملية الشراء الأخيرة.',
        'time': 'أمس',
        'type': 'points',
        'isRead': true,
      },
      {
        'id': 4,
        'title': 'تحديث النظام ⚙️',
        'body': 'قمنا بإضافة ميزات جديدة لتحسين تجربة تسوقك.',
        'time': 'منذ يومين',
        'type': 'system',
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        titleText: LocaleKeys.common.notifications.tr(context: context),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'تحديد الكل كمقروء',
              style: TextStyle(
                color: AppColors.primaryOrange,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          8.horizontalSpace,
        ],
      ),
      body: dummyNotifications.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: dummyNotifications.length,
              itemBuilder: (context, index) {
                final notification = dummyNotifications[index];
                return AppAnimation.fadeInRight(
                  delay: Duration(milliseconds: index * 100),
                  child: _NotificationCard(
                    notification: notification,
                    isDark: isDark,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 64.sp,
              color: AppColors.primaryOrange,
            ),
          ),
          24.verticalSpace,
          Text(
            'لا توجد إشعارات حالياً',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          8.verticalSpace,
          Text(
            'ستظهر هنا الإشعارات الخاصة بطلباتك وعروضنا الجديدة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: theme.hintColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final bool isDark;

  const _NotificationCard({
    required this.notification,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRead = notification['isRead'] as bool;

    IconData iconData;
    Color iconColor;
    
    switch (notification['type']) {
      case 'order':
        iconData = Icons.local_shipping_outlined;
        iconColor = Colors.blue;
        break;
      case 'discount':
        iconData = Icons.local_offer_outlined;
        iconColor = Colors.orange;
        break;
      case 'points':
        iconData = Icons.stars_rounded;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.info_outline_rounded;
        iconColor = AppColors.primaryOrange;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isRead 
          ? (isDark ? theme.cardColor.withValues(alpha: 0.5) : Colors.grey[50])
          : (isDark ? theme.cardColor : Colors.white),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isRead 
            ? Colors.transparent 
            : AppColors.primaryOrange.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: isRead ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with background
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(iconData, color: iconColor, size: 22.sp),
              ),
              16.horizontalSpace,
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryOrange,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    4.verticalSpace,
                    Text(
                      notification['body'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.hintColor,
                        height: 1.4,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      notification['time'],
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: theme.hintColor.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
