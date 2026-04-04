import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class VouchersWidget extends StatelessWidget {
  const VouchersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'قسائم الهدايا والمكافآت',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                'عرض الكل',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => 12.horizontalSpace,
            itemBuilder: (context, index) => _buildVoucherCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherCard(int index) {
    final colors = [
      [const Color(0xFF465CA7), const Color(0xFF6478BD)],
      [const Color(0xFFFF6D00), const Color(0xFFF08320)],
      [const Color(0xFF2E7D32), const Color(0xFF4CAF50)],
      [const Color(0xFFD32F2F), const Color(0xFFEF5A56)],
    ];

    return Container(
      width: 220.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors[index % colors.length],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colors[index % colors.length][0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Semi-circle cutouts (Voucher aesthetic)
          Positioned(
            left: -10,
            top: 35.h,
            child: CircleAvatar(radius: 10, backgroundColor: AppColors.baseScaffold.withOpacity(0.5)),
          ),
          Positioned(
            right: -10,
            top: 35.h,
            child: CircleAvatar(radius: 10, backgroundColor: AppColors.baseScaffold.withOpacity(0.5)),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'خصم ${index == 0 ? "50" : "20"} LE',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        index == 0 ? 'على أول طلب لك' : 'على منتجات العناية بالبشرة',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'استخدم',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: colors[index % colors.length][0],
                    ),
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
