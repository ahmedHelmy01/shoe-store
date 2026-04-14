import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/models/boarding_row.dart';

class BoardingForm extends StatefulWidget {
  final BoardingRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const BoardingForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<BoardingForm> createState() => _BoardingFormState();
}

class _BoardingFormState extends State<BoardingForm> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _descCtrl = TextEditingController(text: widget.initial?.description ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'is_active': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _titleCtrl,
          label: 'Boarding Title',
          hint: 'e.g. Welcome to WebStore',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _descCtrl,
          label: 'Description',
          hint: 'Short onboarding text...',
          maxLines: 3,
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
          child: Text(widget.initial == null ? 'Create Boarding' : 'Save Changes'),
        ),
      ],
    );
  }
}
