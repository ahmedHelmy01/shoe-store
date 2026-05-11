import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';

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
  bool _isActive = true;
  XFile? _logoFile;
  // Removed _uploadedLogoPath as we now use direct file upload
  bool _removeInitialLogo = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'name_ar': _nameArCtrl.text.trim(),
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
          AppTextField(
            controller: _nameCtrl,
            label: 'Company Name (English)',
            hint: 'e.g. Pfizer',
            validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _nameArCtrl,
            label: 'Company Name (Arabic)',
            hint: 'e.g. فايزر',
            validator: (v) => v == null || v.isEmpty ? 'Arabic name is required' : null,
          ),
          const SizedBox(height: 24),
          AdminImagePicker(
            label: 'Company Logo',
            initialImage: widget.initial?.logoUrl,
            onImageSelected: (file) => setState(() => _logoFile = file),
            onRemoveInitial: () => setState(() => _removeInitialLogo = true),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Is Active'),
            value: _isActive,
            onChanged: (val) => setState(() => _isActive = val),
            contentPadding: EdgeInsets.zero,
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
