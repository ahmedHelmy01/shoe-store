import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/models/country_row.dart';

class CountryForm extends StatefulWidget {
  final CountryRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const CountryForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<CountryForm> createState() => _CountryFormState();
}

class _CountryFormState extends State<CountryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _phoneCodeCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameEnCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _codeCtrl = TextEditingController(text: widget.initial?.code ?? '');
    _phoneCodeCtrl = TextEditingController(text: widget.initial?.phoneCode ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameEnCtrl.dispose();
    _nameArCtrl.dispose();
    _codeCtrl.dispose();
    _phoneCodeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'name': _nameEnCtrl.text.trim(),
        'name_ar': _nameArCtrl.text.trim(),
        'code': _codeCtrl.text.trim(),
        'phone_code': _phoneCodeCtrl.text.trim(),
        'is_active': _isActive,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _nameEnCtrl,
                  label: 'Name (English)',
                  hint: 'e.g. Egypt',
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _nameArCtrl,
                  label: 'Name (Arabic)',
                  hint: 'مثال: مصر',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _codeCtrl,
                  label: 'Country Code',
                  hint: 'e.g. EG',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _phoneCodeCtrl,
                  label: 'Phone Code',
                  hint: 'e.g. +20',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Is Active'),
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? 'Add Country' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
