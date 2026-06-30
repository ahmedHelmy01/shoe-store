import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class PageForm extends StatefulWidget {
  final PageRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data, XFile? imageFile) onSave;

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
  bool _isActive = true;
  XFile? _imageFile;
  // Removed _uploadedImagePath as we now use direct file upload
  bool _removeInitialImage = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _titleArCtrl = TextEditingController(text: widget.initial?.titleAr ?? '');
    _contentCtrl = TextEditingController(text: widget.initial?.content ?? '');
    _contentArCtrl = TextEditingController(text: widget.initial?.contentAr ?? '');
    _slugCtrl = TextEditingController(text: widget.initial?.slug ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _titleArCtrl.dispose();
    _contentCtrl.dispose();
    _contentArCtrl.dispose();
    _slugCtrl.dispose();
    super.dispose();
  }

  String _sanitizeSlug(String input) {
    final slug = input.toLowerCase().trim();
    final cleaned = slug.replaceAll(RegExp(r'[^a-z0-9\s-]'), '').trim();
    return cleaned.replaceAll(RegExp(r'\s+'), '-').replaceAll(RegExp(r'-+'), '-');
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final rawSlug = _slugCtrl.text.trim();
      final slug = rawSlug.isEmpty
          ? _sanitizeSlug(_titleCtrl.text)
          : _sanitizeSlug(rawSlug);
      final data = <String, dynamic>{
        'title': _titleCtrl.text.trim(),
        'title_ar': _titleArCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'content_ar': _contentArCtrl.text.trim(),
        'slug': slug,
        'is_active': _isActive,
      };

      if (_removeInitialImage && _imageFile == null) {
        data['image'] = '';
      } else if (_imageFile == null && widget.initial?.image != null) {
        // Keep existing image path if not changed or removed
        data['image'] = widget.initial!.image;
      }

      widget.onSave(data, _imageFile);
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
                    label: AdminLocalizations.translate(context, 'page title (en)'),
                    hint: AdminLocalizations.translate(context, 'e.g. terms & conditions'),
                    borderRadius: 14,
                    validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'required') : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _titleArCtrl,
                    label: AdminLocalizations.translate(context, 'page title (ar)'),
                    hint: 'مثال: الشروط والأحكام',
                    borderRadius: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _slugCtrl,
              label: AdminLocalizations.translate(context, 'slug (url)'),
              hint: AdminLocalizations.translate(context, 'e.g. terms-and-conditions'),
              borderRadius: 14,
              validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'required') : null,
            ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _contentCtrl,
              label: AdminLocalizations.translate(context, 'page content (en)'),
              hint: AdminLocalizations.translate(context, 'enter page content in english...'),
              maxLines: 6,
              borderRadius: 14,
            ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _contentArCtrl,
              label: AdminLocalizations.translate(context, 'page content (ar)'),
              hint: 'أدخل محتوى الصفحة باللغة العربية...',
              maxLines: 6,
              borderRadius: 14,
            ),
            const SizedBox(height: 20),
            AdminImagePicker(
              label: AdminLocalizations.translate(context, 'featured image'),
              initialImage: widget.initial?.imageUrl,
              onImageSelected: (file) => setState(() => _imageFile = file),
              onRemoveInitial: () => setState(() => _removeInitialImage = true),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(AdminLocalizations.translate(context, 'published'), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(AdminLocalizations.translate(context, 'make this page visible to customers')),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: _submit,
              isLoading: widget.isSaving,
              child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'create page') : AdminLocalizations.translate(context, 'save changes')),
            ),
          ],
        ),
      ),
    );
  }
}
