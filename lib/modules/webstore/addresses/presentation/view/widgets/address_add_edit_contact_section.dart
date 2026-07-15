import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'address_form_section.dart';
import 'address_form_text_field.dart';

class AddressAddEditContactSection extends StatelessWidget {
  final TextEditingController phoneCtrl;
  final TextEditingController notesCtrl;

  const AddressAddEditContactSection({
    super.key,
    required this.phoneCtrl,
    required this.notesCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final keys = LocaleKeys.webstore.addresses;
    return AddressFormSection(
      title: keys.contact_notes.tr(context: context),
      icon: Icons.contact_phone_outlined,
      children: [
        AddressFormTextField(
          controller: phoneCtrl,
          label: LocaleKeys.common.phone.tr(context: context),
          hint: '01123949058',
          icon: Icons.phone_iphone_rounded,
          keyboardType: TextInputType.phone,
          isRequired: true,
          validator: (v) => v == null || v.trim().isEmpty
              ? keys.phone_required.tr(context: context)
              : null,
        ),
        AddressFormTextField(
          controller: notesCtrl,
          label: keys.additional_notes.tr(context: context),
          hint: keys.notes_hint.tr(context: context),
          icon: Icons.notes_rounded,
          maxLines: 3,
        ),
      ],
    );
  }
}
