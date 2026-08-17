import 'package:erp/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CatalogProductsFilterAction extends StatelessWidget {
  final int activeFiltersCount;
  final VoidCallback onTap;

  const CatalogProductsFilterAction({
    super.key,
    required this.activeFiltersCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(onPressed: onTap, icon: const Icon(Icons.tune_rounded)),
          if (activeFiltersCount > 0)
            PositionedDirectional(
              top: 6,
              end: 4,
              child: Container(
                height: 18.h,
                width: 18.h,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primaryWine,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$activeFiltersCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
