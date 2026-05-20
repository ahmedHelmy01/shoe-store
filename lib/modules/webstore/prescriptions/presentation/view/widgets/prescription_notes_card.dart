import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/prescriptions/data/models/prescription_model.dart';

class PrescriptionNotesCard extends StatelessWidget {
  final PrescriptionModel prescription;
  final bool isDark;
  final VoidCallback onEdit;

  const PrescriptionNotesCard({
    super.key,
    required this.prescription,
    required this.isDark,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd hh:mm a').format(prescription.createdAt);

    return AppAnimation.fadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2640) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.webstore.prescriptions.attached_notes.tr(context: context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_note_rounded, color: AppColors.primaryOrange),
                  iconSize: 26.sp,
                ),
              ],
            ),
            12.verticalSpace,
            Text(
              prescription.note.isNotEmpty
                  ? prescription.note
                  : LocaleKeys.webstore.prescriptions.no_attached_notes.tr(context: context),
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.5,
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
            const Divider(height: 32, thickness: 0.8),
            _DetailRow(
              icon: Icons.calendar_today_rounded,
              title: LocaleKeys.webstore.prescriptions.sent_date.tr(context: context),
              value: formattedDate,
              isDark: isDark,
            ),
            8.verticalSpace,
            _DetailRow(
              icon: Icons.tag_rounded,
              title: LocaleKeys.webstore.prescriptions.prescription_number.tr(context: context),
              value: '#${prescription.id}',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isDark;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey),
        8.horizontalSpace,
        Text(
          title,
          style: TextStyle(fontSize: 13.sp, color: Colors.grey),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textColor,
          ),
        ),
      ],
    );
  }
}
