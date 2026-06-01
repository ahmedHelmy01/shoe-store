import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';

class WebStoreOrderDetailsSummaryCard extends StatelessWidget {
  final String orderNumber;
  final String statusName;
  final Color statusColor;
  final String dateStr;
  final Map<String, dynamic>? paymentMethod;
  final bool isCancelled;
  final String? cancelledReason;

  const WebStoreOrderDetailsSummaryCard({
    super.key,
    required this.orderNumber,
    required this.statusName,
    required this.statusColor,
    required this.dateStr,
    this.paymentMethod,
    required this.isCancelled,
    this.cancelledReason,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppCard(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${LocaleKeys.webstore.orders.order_number.tr(context: context)}: $orderNumber',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      statusName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${LocaleKeys.webstore.orders.date.tr(context: context)}:',
                    style: TextStyle(color: theme.hintColor, fontSize: 14.sp),
                  ),
                  Text(
                    dateStr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                ],
              ),
              if (paymentMethod != null) ...[
                8.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.webstore.orders.payment.tr(context: context),
                      style: TextStyle(color: theme.hintColor, fontSize: 14.sp),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          paymentMethod!['type'] == 'card' ? Icons.credit_card : Icons.money,
                          size: 14.sp,
                          color: theme.hintColor,
                        ),
                        4.horizontalSpace,
                        Text(
                          paymentMethod!['name']?.toString() ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (isCancelled) ...[
          16.verticalSpace,
          AppCard(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(Icons.cancel_rounded, color: Colors.red, size: 24.sp),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.webstore.orders.order_cancelled.tr(context: context),
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      if (cancelledReason != null && cancelledReason!.isNotEmpty) ...[
                        4.verticalSpace,
                        Text(
                          cancelledReason!,
                          style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
