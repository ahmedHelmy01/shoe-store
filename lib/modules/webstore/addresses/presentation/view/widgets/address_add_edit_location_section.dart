import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'address_form_section.dart';
import 'address_form_text_field.dart';

class AddressAddEditLocationSection extends StatelessWidget {
  final TextEditingController areaCtrl;
  final TextEditingController blockCtrl;
  final TextEditingController streetCtrl;
  final TextEditingController buildingCtrl;
  final TextEditingController floorCtrl;
  final TextEditingController apartmentCtrl;

  const AddressAddEditLocationSection({
    super.key,
    required this.areaCtrl,
    required this.blockCtrl,
    required this.streetCtrl,
    required this.buildingCtrl,
    required this.floorCtrl,
    required this.apartmentCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final keys = LocaleKeys.webstore.addresses;
    return AddressFormSection(
      title: keys.location_details.tr(context: context),
      icon: Icons.location_on_outlined,
      children: [
        AddressFormTextField(
          controller: areaCtrl,
          label: keys.area.tr(context: context),
          hint: keys.area_hint.tr(context: context),
          icon: Icons.place_outlined,
          isRequired: true,
          validator: (v) => v == null || v.trim().isEmpty
              ? keys.area_required.tr(context: context)
              : null,
        ),
        AddressFormTextField(
          controller: blockCtrl,
          label: keys.block.tr(context: context),
          hint: keys.block_hint.tr(context: context),
          icon: Icons.grid_view_rounded,
          isRequired: true,
          validator: (v) => v == null || v.trim().isEmpty
              ? keys.block_required.tr(context: context)
              : null,
        ),
        AddressFormTextField(
          controller: streetCtrl,
          label: keys.street.tr(context: context),
          hint: keys.street_hint.tr(context: context),
          icon: Icons.signpost_outlined,
          isRequired: true,
          validator: (v) => v == null || v.trim().isEmpty
              ? keys.street_required.tr(context: context)
              : null,
        ),
        AddressFormTextField(
          controller: buildingCtrl,
          label: keys.building.tr(context: context),
          hint: keys.building_hint.tr(context: context),
          icon: Icons.apartment_rounded,
          isRequired: true,
          validator: (v) => v == null || v.trim().isEmpty
              ? keys.building_required.tr(context: context)
              : null,
        ),
        AddressFormTextField(
          controller: floorCtrl,
          label: keys.floor.tr(context: context),
          hint: keys.floor_hint.tr(context: context),
          icon: Icons.stairs_outlined,
        ),
        AddressFormTextField(
          controller: apartmentCtrl,
          label: keys.apartment.tr(context: context),
          hint: keys.apartment_hint.tr(context: context),
          icon: Icons.door_front_door_outlined,
        ),
      ],
    );
  }
}
