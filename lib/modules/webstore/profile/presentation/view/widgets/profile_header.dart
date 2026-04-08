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
        Stack(
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryOrange, width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=200&auto=format&fit=crop'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(color: AppColors.primaryOrange, shape: BoxShape.circle),
                  child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16.sp),
                ),
              ),
          ],
        ),
        16.verticalSpace,
        Text(
          name,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
        ),
        Text(
          email,
          style: TextStyle(fontSize: 13.sp, color: theme.hintColor),
        ),
      ],
    );
  }
}
