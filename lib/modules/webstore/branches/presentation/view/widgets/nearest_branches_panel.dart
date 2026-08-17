import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/utils/open_launcher.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';
import 'package:erp/modules/webstore/branches/presentation/view/widgets/distance_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NearestBranchesPanel extends StatelessWidget {
  final List<BranchModel> nearestBranches;
  final Map<int, double> distanceByBranchId;
  final ValueChanged<BranchModel> onTapBranch;
  final ValueChanged<BranchModel>? onTapDirections;

  const NearestBranchesPanel({
    super.key,
    required this.nearestBranches,
    required this.distanceByBranchId,
    required this.onTapBranch,
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
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18.r),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.w, 10.h, 12.w, 8.h),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryWine.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(
                    Icons.near_me_rounded,
                    size: 18,
                    color: AppColors.primaryWine,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أقرب الفروع إليك',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                          color: titleColor,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        'اختر فرعًا لعرضه على الخريطة',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: subtitleColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: border),
          ...nearestBranches.map((branch) {
            final d = distanceByBranchId[branch.id];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTapBranch(branch),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    12.w,
                    10.h,
                    12.w,
                    10.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryWine,
                          shape: BoxShape.circle,
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          branch.nameAr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: titleColor,
                          ),
                        ),
                      ),
                      if (d != null) ...[
                        8.horizontalSpace,
                        DistancePill(meters: d, dense: true),
                      ] else ...[
                        8.horizontalSpace,
                        Text(
                          '--',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: subtitleColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      8.horizontalSpace,
                      if ((branch.phone ?? '').trim().isNotEmpty)
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
                                  : AppColors.primaryWine,
                            ),
                          ),
                        ),
                      if ((branch.phone ?? '').trim().isNotEmpty)
                        8.horizontalSpace,
                      if (onTapDirections != null)
                        InkResponse(
                          radius: 22.r,
                          onTap: () => onTapDirections!(branch),
                          child: Container(
                            width: 34.w,
                            height: 34.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryWine.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.primaryWine.withValues(
                                  alpha: 0.18,
                                ),
                              ),
                            ),
                            child: const Icon(
                              Icons.directions_rounded,
                              size: 18,
                              color: AppColors.primaryWine,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
