import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

class AppErrorWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;
  final IconData? icon;

  const AppErrorWidget({super.key, this.errorMessage, this.onRetry, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: AppAnimation.fadeInUp(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.boldOrange.withOpacity(isDark ? 0.15 : 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.cloud_off_rounded,
                  size: 64.sp,
                  color: AppColors.boldOrange,
                ),
              ),
              24.verticalSpace,
              Text(
                _getFriendlyMessage(context),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
              12.verticalSpace,
              if (errorMessage != null)
                Text(
                  _isTechnical(errorMessage!)
                      ? LocaleKeys.common.check_internet.tr(context: context)
                      : errorMessage!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              32.verticalSpace,
              if (onRetry != null)
                SizedBox(
                  width: 200.w,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      LocaleKeys.common.retry.tr(context: context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isTechnical(String msg) {
    final technicalTerms = [
      'ClientException',
      'HttpException',
      'SocketException',
      'Handshake',
      'Connection closed',
      'Timeout',
    ];
    return technicalTerms.any((term) => msg.contains(term));
  }

  String _getFriendlyMessage(BuildContext context) {
    if (errorMessage != null && _isTechnical(errorMessage!)) {
      return LocaleKeys.common.no_internet.tr(context: context);
    }
    return LocaleKeys.common.error.tr(context: context);
  }
}
