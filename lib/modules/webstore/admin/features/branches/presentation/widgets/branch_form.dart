import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';

class BranchForm extends StatefulWidget {
  final BranchRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const BranchForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<BranchForm> createState() => _BranchFormState();
}

class _BranchFormState extends State<BranchForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _addressArCtrl;
  late final TextEditingController _latitudeCtrl;
  late final TextEditingController _longitudeCtrl;
  late bool _isActive;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _codeCtrl = TextEditingController(text: widget.initial?.code ?? '');
    _phoneCtrl = TextEditingController(text: widget.initial?.phone ?? '');
    _emailCtrl = TextEditingController(text: widget.initial?.email ?? '');
    _addressCtrl = TextEditingController(text: widget.initial?.address ?? '');
    _addressArCtrl = TextEditingController(text: widget.initial?.addressAr ?? '');
    _latitudeCtrl = TextEditingController(
      text: widget.initial?.latitude?.toString() ?? '',
    );
    _longitudeCtrl = TextEditingController(
      text: widget.initial?.longitude?.toString() ?? '',
    );
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _codeCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _addressArCtrl.dispose();
    _latitudeCtrl.dispose();
    _longitudeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    final latitude = double.tryParse(_latitudeCtrl.text.trim());
    final longitude = double.tryParse(_longitudeCtrl.text.trim());

    widget.onSave({
      'name': _nameCtrl.text.trim(),
      if (_nameArCtrl.text.trim().isNotEmpty) 'name_ar': _nameArCtrl.text.trim(),
      if (_codeCtrl.text.trim().isNotEmpty) 'code': _codeCtrl.text.trim(),
      if (_phoneCtrl.text.trim().isNotEmpty) 'phone': _phoneCtrl.text.trim(),
      if (_emailCtrl.text.trim().isNotEmpty) 'email': _emailCtrl.text.trim(),
      if (_addressCtrl.text.trim().isNotEmpty) 'address': _addressCtrl.text.trim(),
      if (_addressArCtrl.text.trim().isNotEmpty) 'address_ar': _addressArCtrl.text.trim(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'is_active': _isActive,
    });
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
            label: 'Branch Name',
            hint: 'e.g. Main Branch',
            borderRadius: 14,
            validator: (value) {
              if ((value ?? '').trim().isEmpty) {
                return 'Branch name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _nameArCtrl,
            label: 'Branch Name (Arabic)',
            hint: 'e.g. الفرع الرئيسي',
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _codeCtrl,
            label: 'Code',
            hint: 'e.g. BR-01',
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _phoneCtrl,
            label: 'Phone',
            hint: 'e.g. 01000000000',
            keyboardType: TextInputType.phone,
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _emailCtrl,
            label: 'Email',
            hint: 'e.g. branch@example.com',
            keyboardType: TextInputType.emailAddress,
            borderRadius: 14,
            validator: (value) {
              final email = (value ?? '').trim();
              if (email.isEmpty) return null;
              final isValid = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
              if (!isValid) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _addressCtrl,
            label: 'Address',
            hint: 'e.g. Kuwait City',
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _addressArCtrl,
            label: 'Address (Arabic)',
            hint: 'e.g. الكويت، العاصمة',
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _latitudeCtrl,
                  label: 'Latitude',
                  hint: 'e.g. 29.37',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  borderRadius: 14,
                  validator: (value) {
                    final v = (value ?? '').trim();
                    if (v.isEmpty) return null;
                    if (double.tryParse(v) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _longitudeCtrl,
                  label: 'Longitude',
                  hint: 'e.g. 47.97',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  borderRadius: 14,
                  validator: (value) {
                    final v = (value ?? '').trim();
                    if (v.isEmpty) return null;
                    if (double.tryParse(v) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
            contentPadding: EdgeInsets.zero,
            title: const Text('Active'),
            subtitle: Text(
              _isEdit ? 'Update active status for this branch' : 'Set initial active status',
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(_isEdit ? 'Save Changes' : 'Create Branch'),
          ),
        ],
      ),
    );
  }
}
