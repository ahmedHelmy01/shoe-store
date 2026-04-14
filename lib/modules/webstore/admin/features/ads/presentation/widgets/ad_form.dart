import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/ads/data/models/ad_row.dart';

class AdForm extends StatefulWidget {
  final AdRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const AdForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<AdForm> createState() => _AdFormState();
}

class _AdFormState extends State<AdForm> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _locationCtrl = TextEditingController(text: widget.initial?.location ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final data = {
      'title': _titleCtrl.text.trim(),
      'location': _locationCtrl.text.trim(),
      'is_active': _isActive,
    };
    widget.onSave(data);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _titleCtrl,
          label: 'Title (English)',
          hint: 'e.g. Summer Sale 2024',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _locationCtrl,
          label: 'Location / Link',
          hint: 'e.g. https://store.com/offers',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        SwitchListTile(
          title: const Text('Is Active'),
          subtitle: const Text('Hide or show this ad on the storefront'),
          value: _isActive,
          onChanged: (v) => setState(() => _isActive = v),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? 'Create Ad' : 'Save Changes'),
        ),
      ],
    );
  }
}
