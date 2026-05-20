import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/constants/app_constants.dart';

class AddressAddEditFooter extends StatelessWidget {
  final bool isDefault;
  final ValueChanged<bool> onDefaultChanged;
  final VoidCallback onSubmit;
  final bool isSaving;
  final bool isEditMode;

  const AddressAddEditFooter({
    super.key,
    required this.isDefault,
    required this.onDefaultChanged,
    required this.onSubmit,
    required this.isSaving,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isDark ? theme.cardColor : AppColors.surface,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.withValues(alpha: 0.15),
            ),
          ),
          child: SwitchListTile.adaptive(
            title: const Text('تعيين كعنوان افتراضي للتوصيل'),
            subtitle: const Text(
              'سيتم اختيار هذا العنوان تلقائياً عند إنهاء الطلب',
            ),
            value: isDefault,
            activeThumbColor: AppColors.primaryOrange,
            contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
            onChanged: onDefaultChanged,
          ),
        ),
        24.verticalSpace,
        AppButton(
          onPressed: onSubmit,
          isLoading: isSaving,
          child: Text(isEditMode ? 'حفظ التعديلات' : 'إضافة العنوان'),
        ),
      ],
    );
  }
}
