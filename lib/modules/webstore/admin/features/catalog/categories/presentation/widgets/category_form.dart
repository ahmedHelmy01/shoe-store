import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';

class CategoryForm extends StatefulWidget {
  final CategoryRow? initial;
  final bool isSaving;
  final double uploadProgress;
  final List<CategoryRow> categories;
  final void Function(Map<String, dynamic> data, XFile? imageFile) onSave;

  const CategoryForm({
    super.key,
    this.initial,
    required this.isSaving,
    this.uploadProgress = 0,
    required this.categories,
    required this.onSave,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _codeCtrl;
  int? _parentId;
  bool _isActive = true;
  XFile? _imageFile;
  // Removed _uploadedImagePath as we now use direct file upload
  bool _removeInitialImage = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _codeCtrl = TextEditingController(text: widget.initial?.code ?? '');
    _parentId = widget.initial?.parentId;
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'name_ar': _nameArCtrl.text.trim(),
        'code': _codeCtrl.text.trim(),
        'parent_id': _parentId,
        'is_active': _isActive,
      };

      if (_removeInitialImage && _imageFile == null) {
        data['image'] = ''; // Tell backend to remove image
      } else if (_imageFile == null && widget.initial?.image != null) {
        // Keep existing image path if not changed or removed
        data['image'] = widget.initial!.image;
      }

      widget.onSave(data, _imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build unique parent dropdown items
    final parentItems = <DropdownMenuItem<int?>>[
      const DropdownMenuItem<int?>(
        value: null,
        child: Text('None'),
      ),
    ];

    final seenIds = <int>{};
    for (final c in widget.categories) {
      if (c.id == widget.initial?.id) continue; // Cannot be its own parent
      if (seenIds.contains(c.id)) continue; // Avoid duplicates
      seenIds.add(c.id);
      parentItems.add(DropdownMenuItem<int?>(
        value: c.id,
        child: Text(c.name),
      ));
    }

    if (_parentId != null && !seenIds.contains(_parentId)) {
      parentItems.add(DropdownMenuItem<int?>(
        value: _parentId,
        child: Text('Category #$_parentId'),
      ));
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _nameCtrl,
              label: 'Category Name (English)',
              hint: 'e.g. Electronics',
              validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _nameArCtrl,
              label: 'Category Name (Arabic)',
              hint: 'e.g. إلكترونيات',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _codeCtrl,
                    label: 'Code',
                    hint: 'e.g. ELEC',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppDropdown<int?>(
                    label: 'Parent Category',
                    hint: 'None',
                    value: _parentId,
                    items: parentItems,
                    onChanged: (val) {
                      setState(() {
                        _parentId = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AdminImagePicker(
              label: 'Category Image',
              initialImage: widget.initial?.imageUrl,
              uploadProgress: widget.uploadProgress,
              onImageSelected: (file) => setState(() => _imageFile = file),
              onRemoveInitial: () => setState(() => _removeInitialImage = true),
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
              child: Text(widget.initial == null ? 'Add Category' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
