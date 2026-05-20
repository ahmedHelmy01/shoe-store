import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class MoreProfileHeader extends StatelessWidget {
  final bool isAuthed;

  const MoreProfileHeader({super.key, required this.isAuthed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isAuthed
              ? [AppColors.primaryBlue, const Color(0xFF1E3A8A)]
              : [theme.cardColor, theme.cardColor],
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2), width: 2),
            ),
            child: CircleAvatar(
              radius: 35.r,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              child: Icon(Icons.person_rounded,
                  size: 40.r,
                  color: isAuthed ? Colors.white : AppColors.primaryBlue),
            ),
          ),
          20.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAuthed
                      ? LocaleKeys.webstore.auth.welcome_back
                          .tr(context: context)
                      : LocaleKeys.webstore.auth.guest_title
                          .tr(context: context),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isAuthed
                        ? Colors.white
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                4.verticalSpace,
                Text(
                  isAuthed
                      ? LocaleKeys.webstore.auth.welcome_family
                          .tr(context: context)
                      : LocaleKeys.webstore.auth.guest_subtitle
                          .tr(context: context),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isAuthed
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
