import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class UserLoyaltyWidget extends StatelessWidget {
  const UserLoyaltyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primaryOrange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLoyaltyItem('نقاطي', '1,250', Icons.stars_rounded),
          ),
          _buildDivider(),
          Expanded(
            child: _buildLoyaltyItem('المحفظة', '450.5 LE', Icons.account_balance_wallet_rounded),
          ),
          _buildDivider(),
          Expanded(
            child: _buildLoyaltyItem('كوبونات', '3', Icons.confirmation_number_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: AppColors.primaryOrange),
            4.horizontalSpace,
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24.h,
      width: 1.w,
      color: AppColors.primaryOrange.withOpacity(0.1),
    );
  }
}
