import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
  late final TextEditingController _cityCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _latitudeCtrl;
  late final TextEditingController _longitudeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _descArCtrl;
  late bool _isActive;
  late bool _isMain;

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
    _cityCtrl = TextEditingController(text: widget.initial?.city ?? '');
    _countryCtrl = TextEditingController(text: widget.initial?.country ?? '');
    _latitudeCtrl = TextEditingController(
      text: widget.initial?.latitude?.toString() ?? '',
    );
    _longitudeCtrl = TextEditingController(
      text: widget.initial?.longitude?.toString() ?? '',
    );
    _descCtrl = TextEditingController(text: widget.initial?.description ?? '');
    _descArCtrl = TextEditingController(text: widget.initial?.descriptionAr ?? '');
    _isActive = widget.initial?.isActive ?? true;
    _isMain = widget.initial?.isMain ?? false;
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
    _cityCtrl.dispose();
    _countryCtrl.dispose();
    _latitudeCtrl.dispose();
    _longitudeCtrl.dispose();
    _descCtrl.dispose();
    _descArCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    final latitude = double.tryParse(_latitudeCtrl.text.trim());
    final longitude = double.tryParse(_longitudeCtrl.text.trim());

    widget.onSave({
      'name': _nameCtrl.text.trim(),
      'name_ar': _nameArCtrl.text.trim(),
      'code': _codeCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
      'address_ar': _addressArCtrl.text.trim(),
      'city': _cityCtrl.text.trim(),
      'country': _countryCtrl.text.trim(),
      'latitude': ?latitude,
      'longitude': ?longitude,
      'description': _descCtrl.text.trim(),
      'description_ar': _descArCtrl.text.trim(),
      'is_active': _isActive ? 1 : 0,
      'is_main': _isMain ? 1 : 0,
      if (widget.initial?.companyId != null) 'company_id': widget.initial!.companyId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _nameCtrl,
                    label: AdminLocalizations.translate(context, 'branch name'),
                    hint: AdminLocalizations.translate(context, 'e.g. main branch'),
                    borderRadius: 14,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return AdminLocalizations.translate(context, 'required');
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _nameArCtrl,
                    label: AdminLocalizations.translate(context, 'branch name (arabic)'),
                    hint: 'e.g. الفرع الرئيسي',
                    borderRadius: 14,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return AdminLocalizations.translate(context, 'required');
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _codeCtrl,
                    label: AdminLocalizations.translate(context, 'code'),
                    hint: AdminLocalizations.translate(context, 'e.g. br-01'),
                    borderRadius: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _phoneCtrl,
                    label: AdminLocalizations.translate(context, 'phone'),
                    hint: AdminLocalizations.translate(context, 'e.g. 01000000000'),
                    keyboardType: TextInputType.phone,
                    borderRadius: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _emailCtrl,
              label: AdminLocalizations.translate(context, 'email'),
              hint: AdminLocalizations.translate(context, 'e.g. branch@example.com'),
              keyboardType: TextInputType.emailAddress,
              borderRadius: 14,
              validator: (value) {
                final email = (value ?? '').trim();
                if (email.isEmpty) return null;
                final isValid = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
                if (!isValid) return AdminLocalizations.translate(context, 'enter a valid email');
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _addressCtrl,
                    label: AdminLocalizations.translate(context, 'address'),
                    hint: AdminLocalizations.translate(context, 'e.g. kuwait city'),
                    borderRadius: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _addressArCtrl,
                    label: AdminLocalizations.translate(context, 'address (arabic)'),
                    hint: 'e.g. الكويت، العاصمة',
                    borderRadius: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _cityCtrl,
                    label: AdminLocalizations.translate(context, 'city'),
                    hint: AdminLocalizations.translate(context, 'e.g. kuwait city'),
                    borderRadius: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _countryCtrl,
                    label: AdminLocalizations.translate(context, 'country code'),
                    hint: AdminLocalizations.translate(context, 'e.g. eg'),
                    borderRadius: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _latitudeCtrl,
                    label: AdminLocalizations.translate(context, 'latitude'),
                    hint: 'e.g. 29.37',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    borderRadius: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _longitudeCtrl,
                    label: AdminLocalizations.translate(context, 'longitude'),
                    hint: 'e.g. 47.97',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    borderRadius: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _descCtrl,
              label: AdminLocalizations.translate(context, 'description'),
              hint: AdminLocalizations.translate(context, 'description'),
              maxLines: 2,
              borderRadius: 14,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _descArCtrl,
              label: AdminLocalizations.translate(context, 'description (arabic)'),
              hint: 'وصف الفرع...',
              maxLines: 2,
              borderRadius: 14,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile.adaptive(
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                    contentPadding: EdgeInsets.zero,
                    title: Text(AdminLocalizations.translate(context, 'active'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(AdminLocalizations.translate(context, 'visible to users'), style: const TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SwitchListTile.adaptive(
                    value: _isMain,
                    onChanged: (value) => setState(() => _isMain = value),
                    contentPadding: EdgeInsets.zero,
                    title: Text(AdminLocalizations.translate(context, 'main branch'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(AdminLocalizations.translate(context, 'primary location'), style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: _submit,
              isLoading: widget.isSaving,
              child: Text(_isEdit ? AdminLocalizations.translate(context, 'save changes') : AdminLocalizations.translate(context, 'create branch')),
            ),
          ],
        ),
      ),
    );
  }
}
