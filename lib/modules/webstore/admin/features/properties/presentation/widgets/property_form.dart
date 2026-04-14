import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/models/property_row.dart';

class PropertyForm extends StatefulWidget {
  final PropertyRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const PropertyForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'name': _nameCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _nameCtrl,
          label: 'Property Name',
          hint: 'e.g. Color, Size, Material',
          borderRadius: 14,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? 'Create Property' : 'Save Changes'),
        ),
      ],
    );
  }
}
