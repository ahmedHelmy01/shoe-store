import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';

class PrescriptionDeleteDialog {
  static Future<void> show(BuildContext context, {required VoidCallback onConfirm}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E2640) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          '${LocaleKeys.webstore.prescriptions.delete_prescription.tr(context: ctx)}؟',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textColor),
        ),
        content: Text(
          LocaleKeys.webstore.prescriptions.delete_confirm.tr(context: ctx),
          style: TextStyle(color: isDark ? Colors.white70 : AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(LocaleKeys.common.cancel.tr(context: ctx), style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            child: Text(LocaleKeys.common.delete.tr(context: ctx), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
