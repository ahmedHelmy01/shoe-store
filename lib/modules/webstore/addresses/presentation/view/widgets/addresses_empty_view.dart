import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressesEmptyView extends StatelessWidget {
  const AddressesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final keys = LocaleKeys.webstore.addresses;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 0.7.sh,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_rounded,
                size: 80.sp,
                color: theme.hintColor.withValues(alpha: 0.3),
              ),
              16.verticalSpace,
              Text(
                keys.empty_title.tr(context: context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                ),
              ),
              8.verticalSpace,
              Text(
                keys.empty_subtitle.tr(context: context),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.hintColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
