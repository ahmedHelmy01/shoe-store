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
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _slugCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.initial?.content ?? '');
    _slugCtrl = TextEditingController(text: widget.initial?.slug ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _slugCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'title': _titleCtrl.text.trim(),
      'content': _contentCtrl.text.trim(),
      'slug': _slugCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _titleCtrl,
          label: 'Page Title',
          hint: 'e.g. Terms & Conditions',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _slugCtrl,
          label: 'Slug (URL)',
          hint: 'e.g. terms-and-conditions',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _contentCtrl,
          label: 'Page Content (HTML support)',
          hint: 'Enter page content...',
          maxLines: 8,
          borderRadius: 14,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? 'Create Page' : 'Save Changes'),
        ),
      ],
    );
  }
}
