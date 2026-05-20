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
    return AddressFormSection(
      title: 'التواصل والملاحظات',
      icon: Icons.contact_phone_outlined,
      children: [
        AddressFormTextField(
          controller: phoneCtrl,
          label: 'رقم الهاتف',
          hint: '01123949058',
          icon: Icons.phone_iphone_rounded,
          keyboardType: TextInputType.phone,
          isRequired: true,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'رقم الهاتف مطلوب' : null,
        ),
        AddressFormTextField(
          controller: notesCtrl,
          label: 'ملاحظات إضافية',
          hint: 'مثال: العمارة بجوار صيدلية العزبي، أو بجوار مسجد السلام',
          icon: Icons.notes_rounded,
          maxLines: 3,
        ),
      ],
    );
  }
}
