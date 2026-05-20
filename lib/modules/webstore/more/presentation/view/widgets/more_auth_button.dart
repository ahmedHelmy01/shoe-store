import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/providers/core_providers.dart';

class MoreAuthButton extends ConsumerWidget {
  final bool isAuthed;

  const MoreAuthButton({super.key, required this.isAuthed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: isAuthed
              ? [const Color(0xFFFF5252), const Color(0xFFFF1744)]
              : [AppColors.primaryOrange, const Color(0xFFFF8C00)],
        ),
        boxShadow: [
          BoxShadow(
            color: (isAuthed ? Colors.red : AppColors.primaryOrange)
                .withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r)),
        ),
        onPressed: () => isAuthed
            ? _handleLogout(context, ref)
            : AppNavigator.push(context, AppRouteNames.webstoreLogin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                isAuthed ? Icons.logout_rounded : Icons.login_rounded,
                color: Colors.white),
            12.horizontalSpace,
            Text(
              isAuthed
                  ? LocaleKeys.common.logout.tr(context: context)
                  : LocaleKeys.webstore.auth.login_or_register
                      .tr(context: context),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    AppStatusDialog.show(
      context,
      status: AppDialogStatus.error,
      title: LocaleKeys.webstore.auth.logout_title.tr(context: context),
      message: LocaleKeys.webstore.auth.logout_confirm.tr(context: context),
      actionText:
          LocaleKeys.webstore.auth.logout_button.tr(context: context),
      onActionPressed: () async {
        await ref.read(sessionManagerProvider).clearSession();
        ref.read(authStateProvider.notifier).setUnauthenticated();
        if (context.mounted) {
          AppNavigator.replace(context, AppRouteNames.webstoreMain);
        }
      },
    );
  }
}
