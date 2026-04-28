import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';

class PageForm extends StatefulWidget {
  final PageRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const PageForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<PageForm> createState() => _PageFormState();
}

class _PageFormState extends State<PageForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _titleArCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _contentArCtrl;
  late final TextEditingController _slugCtrl;
  late final TextEditingController _imageCtrl;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _titleArCtrl = TextEditingController(text: widget.initial?.titleAr ?? '');
    _contentCtrl = TextEditingController(text: widget.initial?.content ?? '');
    _contentArCtrl = TextEditingController(text: widget.initial?.contentAr ?? '');
    _slugCtrl = TextEditingController(text: widget.initial?.slug ?? '');
    _imageCtrl = TextEditingController(text: widget.initial?.image ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _titleArCtrl.dispose();
    _contentCtrl.dispose();
    _contentArCtrl.dispose();
    _slugCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'title': _titleCtrl.text.trim(),
        'title_ar': _titleArCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'content_ar': _contentArCtrl.text.trim(),
        'slug': _slugCtrl.text.trim(),
        'image': _imageCtrl.text.trim(),
        'is_active': _isActive,
      });
    }
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
                    controller: _titleCtrl,
                    label: 'Page Title (EN)',
                    hint: 'e.g. Terms & Conditions',
                    borderRadius: 14,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _titleArCtrl,
                    label: 'Page Title (AR)',
                    hint: 'مثال: الشروط والأحكام',
                    borderRadius: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _slugCtrl,
              label: 'Slug (URL)',
              hint: 'e.g. terms-and-conditions',
              borderRadius: 14,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _imageCtrl,
              label: 'Banner Image Path/URL',
              hint: 'uploads/pages/about.jpg',
              borderRadius: 14,
            ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _contentCtrl,
              label: 'Page Content (EN)',
              hint: 'Enter page content in English...',
              maxLines: 6,
              borderRadius: 14,
            ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _contentArCtrl,
              label: 'Page Content (AR)',
              hint: 'أدخل محتوى الصفحة باللغة العربية...',
              maxLines: 6,
              borderRadius: 14,
            ),
            const SizedBox(height: 18),
            SwitchListTile(
              title: const Text('Published', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Make this page visible to customers'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: _submit,
              isLoading: widget.isSaving,
              child: Text(widget.initial == null ? 'Create Page' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
