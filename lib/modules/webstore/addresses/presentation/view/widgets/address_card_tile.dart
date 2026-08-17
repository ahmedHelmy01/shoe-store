import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'package:erp/modules/webstore/addresses/presentation/utils/address_localization.dart';

class AddressCardTile extends StatelessWidget {
  final AddressModel address;
  final bool isDark;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSetDefault;

  const AddressCardTile({
    super.key,
    required this.address,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final keys = LocaleKeys.webstore.addresses;
    final theme = Theme.of(context);
    final primaryColor = address.isDefault ? AppColors.primaryWine : theme.primaryColor;
    
    // الألوان الهادئة جداً للدوائر (calm and soothing colors)
    final circleColor1 = isDark ? Colors.white.withOpacity(0.02) : primaryColor.withOpacity(0.03);
    final circleColor2 = isDark ? Colors.white.withOpacity(0.01) : Colors.grey.withOpacity(0.04);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: address.isDefault 
              ? primaryColor.withOpacity(0.3) 
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!),
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // الدوائر الجمالية بألوان هادئة جداً
            Positioned(
              right: -40.w,
              top: -40.h,
              child: Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor1,
                ),
              ),
            ),
            Positioned(
              left: -30.w,
              bottom: -50.h,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor2,
                ),
              ),
            ),
            // إضافة تأثير الزجاج (Glassmorphism blur) فوق الدوائر لتبدو أكثر رُقياً
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

            // المحتوى الرئيسي
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: address.isDefault 
                              ? primaryColor.withOpacity(0.1) 
                              : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: address.isDefault ? primaryColor : theme.hintColor,
                          size: 22.sp,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address.localizedDisplayTitle(context),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            if (address.isDefault) ...[
                              6.verticalSpace,
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                                ),
                                child: Text(
                                  keys.default_badge.tr(context: context),
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  16.verticalSpace,
                  
                  // تفاصيل العنوان بصندوق هادئ الشفافية
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.02) : Colors.grey[50]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.map_outlined, size: 16.sp, color: theme.hintColor),
                            8.horizontalSpace,
                            Expanded(
                              child: Text(
                                address.localizedPrintableAddress(context),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (address.phone != null && address.phone!.isNotEmpty) ...[
                          10.verticalSpace,
                          Row(
                            children: [
                              Icon(Icons.phone_in_talk_outlined, size: 16.sp, color: theme.hintColor),
                              8.horizontalSpace,
                              Text(
                                address.phone!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: theme.textTheme.bodyMedium?.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (address.notes != null && address.notes!.isNotEmpty) ...[
                          10.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline_rounded, size: 16.sp, color: theme.hintColor),
                              8.horizontalSpace,
                              Expanded(
                                child: Text(
                                  address.notes!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: theme.hintColor,
                                    fontStyle: FontStyle.italic,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  16.verticalSpace,
                  
                  // الإجراءات (الأزرار)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!address.isDefault && onSetDefault != null)
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: onSetDefault,
                              borderRadius: BorderRadius.circular(8.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_outline_rounded, size: 16.sp, color: theme.hintColor),
                                    6.horizontalSpace,
                                    Text(
                                      keys.set_as_default.tr(context: context),
                                      style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (address.isDefault || onSetDefault == null) const Spacer(),
                      
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.primaryWine.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: onEdit,
                          icon: Icon(
                            Icons.edit_outlined, 
                            color: isDark ? AppColors.primaryWine : AppColors.primaryWine, 
                            size: 18.sp
                          ),
                          tooltip: LocaleKeys.common.edit.tr(context: context),
                          splashRadius: 24,
                        ),
                      ),
                      8.horizontalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: onDelete,
                          icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400], size: 18.sp),
                          tooltip: LocaleKeys.common.delete.tr(context: context),
                          splashRadius: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
