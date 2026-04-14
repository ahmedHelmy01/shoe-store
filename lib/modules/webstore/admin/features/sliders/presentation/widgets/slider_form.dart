import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/models/slider_row.dart';

class SliderForm extends StatefulWidget {
  final SliderRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const SliderForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<SliderForm> createState() => _SliderFormState();
}

class _SliderFormState extends State<SliderForm> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _linkCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _linkCtrl = TextEditingController(text: widget.initial?.link ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _linkCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'title': _titleCtrl.text.trim(),
      'link': _linkCtrl.text.trim(),
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
          label: 'Slider Title',
          hint: 'e.g. Mega Summer Sale',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _linkCtrl,
          label: 'Action Link',
          hint: 'e.g. /category/electronics',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        SwitchListTile(
          title: const Text('Is Active'),
          subtitle: const Text('Display this slider on the home screen'),
          value: _isActive,
          onChanged: (v) => setState(() => _isActive = v),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? 'Create Slider' : 'Save Changes'),
        ),
      ],
    );
  }
}
