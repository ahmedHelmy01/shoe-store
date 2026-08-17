import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/core/providers/core_providers.dart';

class BranchSelectionSheet extends ConsumerWidget {
  const BranchSelectionSheet({super.key});

  /// Static helper to show the sheet and handle the branch update logic automatically.
  /// Used in the Home header and other places where immediate update is needed.
  static Future<int?> show(BuildContext context, WidgetRef ref) async {
    final branchId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BranchSelectionSheet(),
    );

    if (branchId != null) {
      final branchState = ref.read(branchVmProvider);
      if (branchState is BranchLoaded) {
        final branch = branchState.branches.firstWhere((b) => b.id == branchId);
        final branchName = context.locale.languageCode == 'ar' ? branch.nameAr : branch.name;

        // Update session and providers
        await ref.read(sessionManagerProvider).setBranchId(branch.id);
        await ref.read(sessionManagerProvider).setBranchName(branchName);
        ref.read(locationProvider.notifier).updateSelectedBranch(branchName);
        
        await ref.read(branchVmProvider.notifier).updateBranch(branch.id.toString());
        ref.read(homeVmProvider.notifier).getLatestProducts();
      }
    }
    return branchId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchState = ref.watch(branchVmProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          24.verticalSpace,
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryWine.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: AppColors.primaryWine,
                  size: 26.sp,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.webstore.auth.select_branch_hint.tr(context: context),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'الرجاء اختيار الفرع الأقرب إليك لإتمام العملية',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          24.verticalSpace,
          if (branchState is BranchLoading)
            const Center(child: CircularProgressIndicator.adaptive())
          else if (branchState is BranchLoaded)
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: branchState.branches.length,
                separatorBuilder: (_, __) => 12.verticalSpace,
                itemBuilder: (context, index) {
                  final branch = branchState.branches[index];
                  final name = context.locale.languageCode == 'ar'
                      ? branch.nameAr
                      : branch.name;

                  return InkWell(
                    onTap: () => Navigator.pop(context, branch.id),
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark 
                            ? Colors.white.withOpacity(0.05) 
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isDark 
                              ? Colors.white.withOpacity(0.1) 
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primaryWine,
                            size: 20.sp,
                          ),
                          16.horizontalSpace,
                          Expanded(
                            child: Text(
                              name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14.sp,
                            color: theme.hintColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Text('No branches found'),
          32.verticalSpace,
        ],
      ),
    );
  }
}
