import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class PointsRedemptionSectionBalanceCard extends StatelessWidget {
  final int balance;
  final double? monetaryValue;

  const PointsRedemptionSectionBalanceCard({
    super.key,
    required this.balance,
    this.monetaryValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppColors.primary.withValues(alpha: 0.08),
          AppColors.primary.withValues(alpha: 0.02),
        ]),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 28.sp),
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
          if (balance > 0 && monetaryValue != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('≈', style: TextStyle(color: theme.hintColor, fontSize: 12.sp)),
                Text(
                  '\$${monetaryValue!.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: Colors.green.shade600),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
