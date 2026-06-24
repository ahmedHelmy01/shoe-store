import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/category_tree_dropdown.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/modules/webstore/admin/features/ads/data/models/ad_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';

class AdForm extends ConsumerStatefulWidget {
  final AdRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data, XFile? imageFile) onSave;

  const AdForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  ConsumerState<AdForm> createState() => _AdFormState();
}

class _AdFormState extends ConsumerState<AdForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _titleArCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _contentArCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _linkUrlCtrl;
  late bool _isActive;
  int? _selectedCategoryId;
  
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
    _locationCtrl = TextEditingController(text: widget.initial?.location ?? 'home');
    _linkUrlCtrl = TextEditingController(text: widget.initial?.linkUrl ?? '');
    _isActive = widget.initial?.isActive ?? true;
    _selectedCategoryId = widget.initial?.productCategoryId;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _titleArCtrl.dispose();
    _contentCtrl.dispose();
    _contentArCtrl.dispose();
    _locationCtrl.dispose();
    _linkUrlCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{
        'title': _titleCtrl.text.trim(),
        'title_ar': _titleArCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'content_ar': _contentArCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'link_url': _linkUrlCtrl.text.trim(),
        'is_active': _isActive,
        'product_category_id': _selectedCategoryId,
      };

      if (_removeInitialImage && _imageFile == null) {
        data['image'] = '';
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
                    label: 'Title (EN)',
                    hint: 'e.g. Special Offer',
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _titleArCtrl,
                    label: 'Title (AR)',
                    hint: 'عرض خاص',
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _contentCtrl,
                    label: 'Content (EN)',
                    hint: 'Buy 1 Get 1',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _contentArCtrl,
                    label: 'Content (AR)',
                    hint: 'اشتري 1 واحصل على 1',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _locationCtrl,
                    label: 'Location',
                    hint: 'home',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _linkUrlCtrl,
                    label: 'Link URL',
                    hint: '/offers',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ref.watch(categoryTreeProvider).when(
              data: (tree) {
                final items = CategoryTreeDropdown.flattenTree(tree);
                return CategoryTreeDropdown(
                  label: 'Category Link',
                  hint: 'Select Category (Optional)',
                  value: items.any((c) => c.id == _selectedCategoryId) ? _selectedCategoryId : null,
                  items: items,
                  onChanged: (v) => setState(() => _selectedCategoryId = v),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text('Error loading categories'),
            ),
            const SizedBox(height: 20),
            AdminImagePicker(
              label: 'Ad Image',
              initialImage: widget.initial?.imageUrl,
              onImageSelected: (file) => setState(() => _imageFile = file),
              onRemoveInitial: () => setState(() => _removeInitialImage = true),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Is Active'),
              subtitle: const Text('Hide or show this ad on the storefront'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: _submit,
              isLoading: widget.isSaving,
              child: Text(widget.initial == null ? 'Create Ad' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
