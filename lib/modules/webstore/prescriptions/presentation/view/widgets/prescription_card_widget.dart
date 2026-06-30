import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/network/network_url.dart';
import 'package:erp/modules/webstore/prescriptions/data/models/prescription_model.dart';

class PrescriptionCardWidget extends StatelessWidget {
  final PrescriptionModel prescription;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PrescriptionCardWidget({
    super.key,
    required this.prescription,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (statusColor, statusText) = _statusInfo(context);
    final formattedDate = DateFormat('yyyy-MM-dd hh:mm a').format(prescription.createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2640) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  _buildImageThumbnail(isDark),
                  16.horizontalSpace,
                  Expanded(child: _buildInfo(context, isDark, statusColor, statusText, formattedDate)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(bool isDark) {
    return Hero(
      tag: 'prescription_img_${prescription.id}',
      child: Container(
        width: 90.w, height: 90.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11.r),
          child: AppImage(imagePath: NetworkUrl.fullUrl(prescription.image), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext ctx, bool isDark, Color statusColor, String statusText, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
              ),
              child: Text(statusText, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: statusColor)),
            ),
            _buildPopupMenu(ctx),
          ],
        ),
        8.verticalSpace,
        Text(
          prescription.note.isNotEmpty ? prescription.note : LocaleKeys.webstore.prescriptions.no_notes.tr(context: ctx),
          maxLines: 2, overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.textColor),
        ),
        8.verticalSpace,
        Row(children: [
          Icon(Icons.calendar_today_rounded, size: 12.sp, color: Colors.grey),
          4.horizontalSpace,
          Text(date, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
        ]),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext ctx) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz_rounded, color: Colors.grey[500], size: 20.sp),
      padding: EdgeInsets.zero,
      onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
      itemBuilder: (_) => [
        PopupMenuItem(value: 'edit', child: Row(children: [
          Icon(Icons.edit_rounded, size: 18.sp, color: AppColors.primaryOrange), 8.horizontalSpace,
          Text(LocaleKeys.webstore.prescriptions.edit_notes.tr(context: ctx)),
        ])),
        PopupMenuItem(value: 'delete', child: Row(children: [
          Icon(Icons.delete_forever_rounded, size: 18.sp, color: AppColors.error), 8.horizontalSpace,
          Text(LocaleKeys.webstore.prescriptions.delete_prescription.tr(context: ctx)),
        ])),
      ],
    );
  }

  (Color, String) _statusInfo(BuildContext ctx) {
    switch (prescription.status.toLowerCase()) {
      case 'approved': return (AppColors.success, LocaleKeys.webstore.prescriptions.status_approved.tr(context: ctx));
      case 'reviewed': return (AppColors.success, LocaleKeys.webstore.prescriptions.status_reviewed.tr(context: ctx));
      case 'rejected': return (AppColors.error, LocaleKeys.webstore.prescriptions.status_rejected.tr(context: ctx));
      default: return (AppColors.orange, LocaleKeys.webstore.prescriptions.status_pending.tr(context: ctx));
    }
  }
}
