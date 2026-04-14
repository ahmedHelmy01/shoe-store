import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';

class CompanyForm extends StatefulWidget {
  final CompanyRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const CompanyForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<CompanyForm> createState() => _CompanyFormState();
}

class _CompanyFormState extends State<CompanyForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.initial?.code ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'name': _nameCtrl.text.trim(),
        'code': _codeCtrl.text.trim(),
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
          AppTextField(
            controller: _nameCtrl,
            label: 'Company Name',
            hint: 'e.g. Samsung, Apple',
            validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _codeCtrl,
            label: 'Company Code',
            hint: 'e.g. SAMSUNG_EGY',
          ),
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? 'Add Company' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
