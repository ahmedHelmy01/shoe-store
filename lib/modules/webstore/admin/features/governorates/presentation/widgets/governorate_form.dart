import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';

class GovernorateForm extends StatefulWidget {
  final GovernorateRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const GovernorateForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<GovernorateForm> createState() => _GovernorateFormState();
}

class _GovernorateFormState extends State<GovernorateForm> {
  late final TextEditingController _nameCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'name': _nameCtrl.text.trim(),
      'is_active': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _nameCtrl,
          label: 'Governorate Name',
          hint: 'e.g. Cairo',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        SwitchListTile(
          title: const Text('Is Active'),
          value: _isActive,
          onChanged: (v) => setState(() => _isActive = v),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? 'Create Governorate' : 'Save Changes'),
        ),
      ],
    );
  }
}
