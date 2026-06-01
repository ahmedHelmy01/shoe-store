import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';

class WebStoreOrderDetailsAddressCard extends StatelessWidget {
  final Map<String, dynamic> address;

  const WebStoreOrderDetailsAddressCard({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.webstore.orders.address.tr(context: context),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        12.verticalSpace,
        AppAnimation.fadeInUp(
          delay: const Duration(milliseconds: 50),
          child: AppCard(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(Icons.location_on_outlined, color: AppColors.primaryOrange, size: 20.sp),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address['name']?.toString() ?? '',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      4.verticalSpace,
                      Text(
                        _buildAddressText(context, address),
                        style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _buildAddressText(BuildContext context, Map<String, dynamic> address) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final parts = <String>[];
    final city = address['city'] as Map<String, dynamic>?;
    final governorate = address['governorate'] as Map<String, dynamic>?;

    if (city != null) {
      parts.add(isAr
          ? (city['name_ar']?.toString() ?? city['name']?.toString() ?? '')
          : (city['name']?.toString() ?? city['name_ar']?.toString() ?? ''));
    }
    if (governorate != null) {
      parts.add(isAr
          ? (governorate['name_ar']?.toString() ?? governorate['name']?.toString() ?? '')
          : (governorate['name']?.toString() ?? governorate['name_ar']?.toString() ?? ''));
    }
    final details = address['address_details']?.toString();
    if (details != null && details.isNotEmpty) {
      parts.add(details);
    }
    return parts.where((p) => p.isNotEmpty).join(', ');
  }
}
