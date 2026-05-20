import 'package:flutter/material.dart';
import 'address_form_section.dart';
import 'address_form_text_field.dart';

class AddressAddEditNameSection extends StatelessWidget {
  final TextEditingController nameController;

  const AddressAddEditNameSection({super.key, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return AddressFormSection(
      title: 'تسمية العنوان',
      icon: Icons.label_outline_rounded,
      children: [
        AddressFormTextField(
          controller: nameController,
          label: 'اسم العنوان',
          hint: 'مثال: البيت، العمل، بيت العائلة',
          icon: Icons.home_work_outlined,
          isRequired: true,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'اسم العنوان مطلوب' : null,
        ),
      ],
    );
  }
}
