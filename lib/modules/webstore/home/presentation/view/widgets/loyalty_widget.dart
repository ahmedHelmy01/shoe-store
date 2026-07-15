import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/points/presentation/view_model/points_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class UserLoyaltyWidget extends ConsumerWidget {
  const UserLoyaltyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final pointsAsync = ref.watch(pointsProvider);
    final homeState = ref.watch(homeVmProvider);

    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      backgroundColor: isDark ? theme.cardColor : AppColors.lightOrange,
      borderRadius: 16.r,
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.primaryOrange.withValues(alpha: 0.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLoyaltyItem(
              LocaleKeys.webstore.home.my_points.tr(context: context),
              pointsAsync.maybeWhen(
                data: (points) => points.balance.toString(),
                orElse: () => '...',
              ),
              Icons.stars_rounded,
              theme,
            ),
          ),
          _buildDivider(isDark, theme),
          Expanded(
            child: _buildLoyaltyItem(
              LocaleKeys.webstore.home.wallet.tr(context: context),
              '0.00 LE',
              Icons.account_balance_wallet_rounded,
              theme,
            ),
          ),
          _buildDivider(isDark, theme),
          Expanded(
            child: _buildLoyaltyItem(
              LocaleKeys.webstore.home.coupons.tr(context: context),
              homeState.coupons.length.toString(),
              Icons.confirmation_number_rounded,
              theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyItem(String title, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: AppColors.primaryOrange),
            4.horizontalSpace,
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark, ThemeData theme) {
    return Container(
      height: 24.h,
      width: 1.w,
      color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.primaryOrange.withValues(alpha: 0.1),
    );
  }
}
