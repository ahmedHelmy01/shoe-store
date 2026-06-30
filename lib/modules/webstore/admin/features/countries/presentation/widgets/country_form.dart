import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/models/country_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
                  label: AdminLocalizations.translate(context, 'name (english)'),
                  hint: AdminLocalizations.translate(context, 'e.g. egypt'),
                  validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'required') : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _nameArCtrl,
                  label: AdminLocalizations.translate(context, 'name (arabic)'),
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
                  label: AdminLocalizations.translate(context, 'country code'),
                  hint: AdminLocalizations.translate(context, 'e.g. eg'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _phoneCodeCtrl,
                  label: AdminLocalizations.translate(context, 'phone code'),
                  hint: AdminLocalizations.translate(context, 'e.g. +20'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(AdminLocalizations.translate(context, 'is active')),
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'add country') : AdminLocalizations.translate(context, 'save changes')),
          ),
        ],
      ),
    );
  }
}
