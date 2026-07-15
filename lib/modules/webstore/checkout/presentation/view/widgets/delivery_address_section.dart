import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'package:erp/modules/webstore/addresses/presentation/utils/address_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';

class DeliveryAddressSection extends StatelessWidget {
  final AddressModel? selectedAddress;

  final List<AddressModel> addresses;
  final ValueChanged<AddressModel> onAddressSelected;

  const DeliveryAddressSection({
    super.key,
    required this.selectedAddress,

    required this.addresses,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          context,
          LocaleKeys.webstore.checkout.delivery_address.tr(context: context),
          onAction: () => _showAddressSelectionBottomSheet(context, addresses),
        ),
        12.verticalSpace,
        AppCard(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primaryOrange,
                  size: 24.sp,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedAddress?.localizedDisplayTitle(context) ??
                          LocaleKeys.webstore.checkout.no_registered_addresses.tr(context: context),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: selectedAddress == null ? Colors.red : null,
                      ),
                    ),
                    if (selectedAddress != null) ...[
                      4.verticalSpace,
                      Text(
                        selectedAddress!.localizedPrintableAddress(context),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryOrange,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              LocaleKeys.common.edit.tr(context: context),
              style: const TextStyle(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  void _showAddressSelectionBottomSheet(
    BuildContext context,
    List<AddressModel> addresses,
  ) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              16.verticalSpace,
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: theme.hintColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              16.verticalSpace,
              Text(
                LocaleKeys.webstore.checkout.choose_delivery_address.tr(context: context),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.verticalSpace,
              if (addresses.isEmpty)
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Text(
                        LocaleKeys.webstore.checkout.no_registered_addresses.tr(context: context),
                        style: TextStyle(fontSize: 14.sp, color: theme.hintColor),
                      ),
                      16.verticalSpace,
                      AppButton(
                        onPressed: () {
                          Navigator.pop(context);
                          AppNavigator.push(
                            context,
                            AppRouteNames.webstoreAddresses,
                          );
                        },
                        height: 48.h,
                        child: Text(
                          LocaleKeys.webstore.checkout.add_new_address.tr(context: context),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final addr = addresses[index];
                      final isSelected = selectedAddress?.id == addr.id;
                      return Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryOrange
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            onAddressSelected(addr);
                            Navigator.pop(context);
                          },
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: isSelected ? AppColors.primaryOrange : null,
                          ),
                          title: Text(
                            addr.localizedDisplayTitle(context),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(addr.localizedPrintableAddress(context)),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryOrange,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              if (addresses.isNotEmpty) ...[
                const Divider(),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    AppNavigator.push(context, AppRouteNames.webstoreAddresses);
                  },
                  leading: const Icon(
                    Icons.settings_suggest_rounded,
                    color: AppColors.primaryOrange,
                  ),
                  title: Text(LocaleKeys.webstore.checkout.manage_registered_addresses.tr(context: context)),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ),
              ],
            ],
            ),
          ),
        );
      },
    );
  }
}
