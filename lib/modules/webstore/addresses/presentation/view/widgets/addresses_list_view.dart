import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'address_card_tile.dart';

class AddressesListView extends StatelessWidget {
  final List<AddressModel> addresses;
  final bool isDark;
  final void Function(AddressModel) onEdit;
  final void Function(AddressModel) onDelete;
  final void Function(AddressModel) onSetDefault;

  const AddressesListView({
    super.key,
    required this.addresses,
    required this.isDark,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 80.h),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return AppAnimation.fadeInUp(
          delay: Duration(milliseconds: index * 50),
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: AddressCardTile(
              address: address,
              isDark: isDark,
              onEdit: () => onEdit(address),
              onDelete: () => onDelete(address),
              onSetDefault: address.isDefault ? null : () => onSetDefault(address),
            ),
          ),
        );
      },
    );
  }
}
