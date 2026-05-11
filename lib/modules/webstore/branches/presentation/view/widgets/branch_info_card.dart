import 'package:erp/modules/webstore/branches/data/branch_model.dart';
import 'package:erp/modules/webstore/branches/presentation/view/widgets/distance_pill.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/utils/open_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BranchInfoCard extends StatelessWidget {
  final BranchModel branch;
  final double? distanceMeters;
  final VoidCallback? onTap;
  final VoidCallback? onTapDirections;

  const BranchInfoCard({
    super.key,
    required this.branch,
    this.distanceMeters,
    this.onTap,
    this.onTapDirections,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF0F172A) : Colors.white;
    final border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final titleColor = isDark ? Colors.white : const Color(0xFF0B1220);
    final bodyColor = isDark ? Colors.white70 : Colors.black54;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: border),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      branch.nameAr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: titleColor,
                      ),
                    ),
                  ),
                  if (distanceMeters != null) ...[
                    8.horizontalSpace,
                    DistancePill(meters: distanceMeters!, dense: false),
                  ],
                ],
              ),
              8.verticalSpace,
              if ((branch.addressAr ?? '').isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    6.horizontalSpace,
                    Expanded(
                      child: Text(
                        branch.addressAr!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.sp, color: bodyColor),
                      ),
                    ),
                  ],
                ),
              if ((branch.phone ?? '').isNotEmpty) ...[
                8.verticalSpace,
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () async {
                      final phone = (branch.phone ?? '').trim();
                      final sanitized = phone.replaceAll(
                        RegExp(r'[^0-9+]'),
                        '',
                      );
                      if (sanitized.isEmpty) return;
                      await openUrl('tel:$sanitized');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.h,
                        horizontal: 6.w,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.call_rounded,
                            size: 16,
                            color: isDark ? Colors.white54 : Colors.black45,
                          ),
                          6.horizontalSpace,
                          Expanded(
                            child: Text(
                              branch.phone!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          8.horizontalSpace,
                          InkResponse(
                            radius: 22.r,
                            onTap: () async {
                              final phone = (branch.phone ?? '').trim();
                              final sanitized = phone.replaceAll(
                                RegExp(r'[^0-9+]'),
                                '',
                              );
                              if (sanitized.isEmpty) return;
                              await openUrl('tel:$sanitized');
                            },
                            child: Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.10)
                                      : Colors.black.withValues(alpha: 0.06),
                                ),
                              ),
                              child: Icon(
                                Icons.phone_in_talk_rounded,
                                size: 18,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.primaryOrange,
                              ),
                            ),
                          ),
                          8.horizontalSpace,
                          if (onTapDirections != null)
                            InkResponse(
                              radius: 22.r,
                              onTap: onTapDirections,
                              child: Container(
                                width: 34.w,
                                height: 34.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOrange.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.primaryOrange.withValues(
                                      alpha: 0.18,
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.directions_rounded,
                                  size: 18,
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
