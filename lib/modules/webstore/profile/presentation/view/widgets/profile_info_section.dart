import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';

class ProfileInfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileInfoSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
        ),
        AppCard(
          padding: EdgeInsets.all(16.w),
          child: Column(children: children),
        ),
      ],
    );
  }
}
