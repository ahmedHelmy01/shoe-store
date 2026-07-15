import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'address_form_section.dart';
import 'address_form_text_field.dart';

class AddressAddEditNameSection extends StatelessWidget {
  final TextEditingController nameController;

  const AddressAddEditNameSection({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    final keys = LocaleKeys.webstore.addresses;
    return AddressFormSection(
      title: keys.name_section_title.tr(context: context),
      icon: Icons.label_outline_rounded,
      children: [
        AddressFormTextField(
          controller: nameController,
          label: keys.address_name.tr(context: context),
          hint: keys.address_name_hint.tr(context: context),
          icon: Icons.home_work_outlined,
          isRequired: true,
          validator: (v) => v == null || v.trim().isEmpty
              ? keys.address_name_required.tr(context: context)
              : null,
        ),
      ],
    );
  }
}
