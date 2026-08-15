import 'package:erp/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BranchMarkerWidget extends StatelessWidget {
  final bool isSelected;

  const BranchMarkerWidget({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? 34.w : 30.w,
          height: isSelected ? 34.w : 30.w,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryOrange
                : const Color(0xFFFF8A3D),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrange.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.store_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
        const Icon(
          Icons.arrow_drop_down,
          color: AppColors.primaryOrange,
          size: 24,
        ),
      ],
    );
  }
}
