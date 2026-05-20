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
    return AddressFormSection(
      title: 'تفاصيل الموقع',
      icon: Icons.location_on_outlined,
      children: [
        AddressFormTextField(
          controller: areaCtrl,
          label: 'المنطقة',
          hint: 'مثال: مدينة نصر، المهندسين',
          icon: Icons.place_outlined,
          isRequired: true,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'المنطقة مطلوبة' : null,
        ),
        AddressFormTextField(
          controller: blockCtrl,
          label: 'القطعة / المجاورة',
          hint: 'مثال: بلوك 5 أو مجاورة 3',
          icon: Icons.grid_view_rounded,
          isRequired: true,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'القطعة/المجاورة مطلوبة' : null,
        ),
        AddressFormTextField(
          controller: streetCtrl,
          label: 'الشارع',
          hint: 'مثال: شارع التحرير، عباس العقاد',
          icon: Icons.signpost_outlined,
          isRequired: true,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'الشارع مطلوب' : null,
        ),
        AddressFormTextField(
          controller: buildingCtrl,
          label: 'المبنى / العمارة',
          hint: 'مثال: عمارة 15، فيلا 2',
          icon: Icons.apartment_rounded,
          isRequired: true,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'المبنى مطلوب' : null,
        ),
        AddressFormTextField(
          controller: floorCtrl,
          label: 'الدور',
          hint: 'مثال: 2 (اختياري)',
          icon: Icons.stairs_outlined,
        ),
        AddressFormTextField(
          controller: apartmentCtrl,
          label: 'الشقة',
          hint: 'مثال: 5 (اختياري)',
          icon: Icons.door_front_door_outlined,
        ),
      ],
    );
  }
}
