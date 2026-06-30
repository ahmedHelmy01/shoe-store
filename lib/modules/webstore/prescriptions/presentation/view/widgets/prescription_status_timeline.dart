import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

class PrescriptionStatusTimeline extends StatelessWidget {
  final String status;
  final bool isDark;

  const PrescriptionStatusTimeline({
    super.key,
    required this.status,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final statusLower = status.toLowerCase();
    final bool isPending = statusLower == 'pending';
    final bool isReviewed = statusLower == 'reviewed';
    final bool isApproved = statusLower == 'approved';
    final bool isRejected = statusLower == 'rejected';
    final bool isCompleted = isReviewed || isApproved;

    return AppAnimation.fadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2640) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.webstore.prescriptions.order_status.tr(context: context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                _TimelineStep(
                  title: LocaleKeys.webstore.prescriptions.status_sent.tr(context: context),
                  isActive: true,
                  isCompleted: true,
                  isLast: false,
                ),
                _TimelineStep(
                  title: isRejected
                      ? LocaleKeys.webstore.prescriptions.status_rejected.tr(context: context)
                      : isApproved
                          ? LocaleKeys.webstore.prescriptions.status_approved.tr(context: context)
                          : LocaleKeys.webstore.prescriptions.status_pending.tr(context: context),
                  isActive: isPending || isCompleted || isRejected,
                  isCompleted: isCompleted || isRejected,
                  isError: isRejected,
                  isLast: false,
                ),
                _TimelineStep(
                  title: LocaleKeys.webstore.prescriptions.status_ready.tr(context: context),
                  isActive: isCompleted,
                  isCompleted: isCompleted,
                  isLast: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String title;
  final bool isActive;
  final bool isCompleted;
  final bool isError;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.isActive,
    required this.isCompleted,
    this.isError = false,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final Color stepColor = isError
        ? AppColors.error
        : isCompleted
            ? AppColors.success
            : isActive
                ? AppColors.primaryOrange
                : Colors.grey[300]!;

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 3.h,
                  color: isCompleted ? AppColors.success : Colors.grey[300]!,
                ),
              ),
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: stepColor.withValues(alpha: 0.15),
                  border: Border.all(color: stepColor, width: 2),
                ),
                child: Icon(
                  isError
                      ? Icons.close_rounded
                      : isCompleted
                          ? Icons.check_rounded
                          : Icons.radio_button_checked_rounded,
                  size: 12.sp,
                  color: stepColor,
                ),
              ),
              Expanded(
                child: Container(
                  height: 3.h,
                  color: isLast
                      ? Colors.transparent
                      : isCompleted
                          ? AppColors.success
                          : Colors.grey[300]!,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: stepColor,
            ),
          ),
        ],
      ),
    );
  }
}
