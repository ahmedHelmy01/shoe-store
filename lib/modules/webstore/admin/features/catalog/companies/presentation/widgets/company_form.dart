import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class CompanyForm extends StatefulWidget {
  final CompanyRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data, XFile? logoFile) onSave;

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
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _descArCtrl;
  bool _isActive = true;
  XFile? _logoFile;
  // Removed _uploadedLogoPath as we now use direct file upload
  bool _removeInitialLogo = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _descCtrl = TextEditingController(text: widget.initial?.description ?? '');
    _descArCtrl = TextEditingController(text: widget.initial?.descriptionAr ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _descCtrl.dispose();
    _descArCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'name_ar': _nameArCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'description_ar': _descArCtrl.text.trim(),
        'is_active': _isActive,
      };

      if (_removeInitialLogo && _logoFile == null) {
        data['logo'] = '';
      }

      // We still pass _logoFile for backward compatibility or if instant upload fails/not used
      widget.onSave(data, _logoFile);
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
                  controller: _nameCtrl,
                  label: AdminLocalizations.translate(context, 'company name (english)'),
                  hint: AdminLocalizations.translate(context, 'e.g. pfizer'),
                  validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'name is required') : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _nameArCtrl,
                  label: AdminLocalizations.translate(context, 'company name (arabic)'),
                  hint: AdminLocalizations.translate(context, 'e.g. pfizer (arabic)'),
                  validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'arabic name is required') : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _descCtrl,
                  label: AdminLocalizations.translate(context, 'description (english)'),
                  hint: AdminLocalizations.translate(context, 'enter description in english'),
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _descArCtrl,
                  label: AdminLocalizations.translate(context, 'description (arabic)'),
                  hint: AdminLocalizations.translate(context, 'enter description in arabic'),
                  maxLines: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AdminImagePicker(
            label: AdminLocalizations.translate(context, 'company logo'),
            initialImage: widget.initial?.logoUrl,
            onImageSelected: (file) => setState(() => _logoFile = file),
            onRemoveInitial: () => setState(() => _removeInitialLogo = true),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: Text(AdminLocalizations.translate(context, 'is active')),
            value: _isActive,
            onChanged: (val) => setState(() => _isActive = val),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'add company') : AdminLocalizations.translate(context, 'save changes')),
          ),
        ],
      ),
    );
  }
}
