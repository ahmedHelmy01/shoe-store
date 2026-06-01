import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class WebStoreOrderTrackTimelineStepWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isActive;
  final bool isCompleted;
  final bool isLast;

  const WebStoreOrderTrackTimelineStepWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isActive,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
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
                    : (isActive
                        ? Center(
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryOrange,
                      ),
                            ),
                          )
                        : null),
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
}
