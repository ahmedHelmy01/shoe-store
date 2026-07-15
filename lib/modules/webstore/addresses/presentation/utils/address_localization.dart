import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'package:flutter/material.dart';

extension AddressModelLocalization on AddressModel {
  String localizedDisplayTitle(BuildContext context) {
    final keys = LocaleKeys.webstore.addresses;
    return (name != null && name!.isNotEmpty)
        ? name!
        : keys.default_delivery_address.tr(context: context);
  }

  String localizedPrintableAddress(BuildContext context) {
    final keys = LocaleKeys.webstore.addresses;
    final parts = [
      if (area != null && area!.isNotEmpty)
        '${keys.area_label.tr(context: context)}: $area',
      if (block != null && block!.isNotEmpty)
        '${keys.block.tr(context: context)}: $block',
      if (street != null && street!.isNotEmpty)
        '${keys.street.tr(context: context)}: $street',
      if (building != null && building!.isNotEmpty)
        '${keys.building_label.tr(context: context)}: $building',
      if (floor != null && floor!.isNotEmpty)
        '${keys.floor_label.tr(context: context)}: $floor',
      if (apartment != null && apartment!.isNotEmpty)
        '${keys.apartment_label.tr(context: context)}: $apartment',
      if (cityName != null) cityName,
      if (governorateName != null) governorateName,
    ];
    return parts.where((p) => p != null && p.isNotEmpty).join('، ');
  }
}
