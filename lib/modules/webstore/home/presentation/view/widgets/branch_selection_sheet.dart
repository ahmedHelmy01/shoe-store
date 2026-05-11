import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/branches/presentation/view_model/branch_view_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';

/// A premium bottom sheet for selecting pharmacy branches.
class BranchSelectionSheet {
  /// Shows the branch selection bottom sheet.
  static void show(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      backgroundColor: theme.cardColor,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.w),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.webstore.home.select_branch.tr(context: context),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              24.verticalSpace,
              Flexible(
                child: Consumer(
                  builder: (context, ref, _) {
                    final branchState = ref.watch(branchVmProvider);

                    if (branchState is BranchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryOrange,
                        ),
                      );
                    } else if (branchState is BranchLoaded) {
                      return _buildBranchList(
                        context,
                        ref,
                        branchState,
                        theme,
                      );
                    } else if (branchState is BranchError) {
                      return Center(child: Text(branchState.message));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              12.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  static Widget _buildBranchList(
    BuildContext context,
    WidgetRef ref,
    BranchLoaded state,
    ThemeData theme,
  ) {
    final branches = state.branches;

    if (branches.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Text(
            LocaleKeys.webstore.home.no_products.tr(context: context),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: branches.length,
      separatorBuilder: (_, __) => Divider(height: 32.h),
      itemBuilder: (context, index) {
        final branch = branches[index];
        final branchName = context.locale.languageCode == 'ar'
            ? branch.nameAr
            : branch.name;
        final isSelected =
            ref.read(locationProvider).selectedBranch == branchName;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            branchName,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? AppColors.primaryOrange
                  : theme.textTheme.bodyLarge?.color,
            ),
          ),
          trailing: isSelected
              ? const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primaryOrange,
                )
              : null,
          onTap: () async {
            await ref.read(sessionManagerProvider).setBranchId(branch.id);
            await ref.read(sessionManagerProvider).setBranchName(branchName);
            ref.read(locationProvider.notifier).updateSelectedBranch(branchName);
            await ref
                .read(branchVmProvider.notifier)
                .updateBranch(branch.id.toString());
            ref.read(homeVmProvider.notifier).getLatestProducts();
            if (context.mounted) Navigator.pop(context);
          },
        );
      },
    );
  }
}
