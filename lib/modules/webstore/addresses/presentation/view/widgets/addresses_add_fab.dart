import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class AddressesAddFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AddressesAddFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColors.primaryOrange,
      icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
      label: Text(
        LocaleKeys.webstore.addresses.add_new.tr(context: context),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
