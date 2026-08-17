import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final bool isEditing;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Replacement for the image with a stylish icon or just a cleaner look
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryWine.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.primaryWine.withValues(alpha: 0.2), width: 2),
          ),
          child: Icon(
            Icons.person_rounded,
            size: 45.sp,
            color: AppColors.primaryWine,
          ),
        ),
        16.verticalSpace,
        Text(
          name,
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
        4.verticalSpace,
        Text(
          email,
          style: TextStyle(fontSize: 14.sp, color: theme.hintColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
