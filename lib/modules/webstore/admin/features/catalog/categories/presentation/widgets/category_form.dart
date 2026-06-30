import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/category_tree_dropdown.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class CategoryForm extends ConsumerStatefulWidget {
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
  ConsumerState<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _descArCtrl;
  int? _parentId;
  bool _hasChildren = false;
  bool _isActive = true;
  XFile? _imageFile;
  // Removed _uploadedImagePath as we now use direct file upload
  bool _removeInitialImage = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.nameEn ?? widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _codeCtrl = TextEditingController(text: widget.initial?.code ?? '');
    _descCtrl = TextEditingController(text: widget.initial?.descriptionEn ?? widget.initial?.description ?? '');
    _descArCtrl = TextEditingController(text: widget.initial?.descriptionAr ?? '');
    _parentId = switch (widget.initial?.parentId) {
      0 => null,
      final v => v,
    };
    _hasChildren = widget.initial?.hasChildren ?? false;
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void didUpdateWidget(CategoryForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initial?.id != oldWidget.initial?.id) {
      _parentId = switch (widget.initial?.parentId) {
        0 => null,
        final v => v,
      };
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _descArCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'name_en': _nameCtrl.text.trim(),
        'name_ar': _nameArCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'description_en': _descCtrl.text.trim(),
        'description_ar': _descArCtrl.text.trim(),
        'code': _codeCtrl.text.trim(),
        'parent_id': _parentId,
        'has_children': _hasChildren,
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

  List<CategoryTreeItem> _buildDropdownItems(List<dynamic> tree) {
    final items = CategoryTreeDropdown.flattenTree(tree);
    // Remove the current category (prevent self-parenting)
    items.removeWhere((item) => item.id == widget.initial?.id);
    // Add "None" option at the top
    items.insert(0, const CategoryTreeItem(id: 0, name: 'None (لا يوجد)', isChild: false));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final categoryTreeAsync = ref.watch(categoryTreeProvider);

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
                      label: AdminLocalizations.translate(context, 'category name (english)'),
                      hint: AdminLocalizations.translate(context, 'e.g. electronics'),
                      validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'name is required') : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: AppTextField(
                      controller: _nameArCtrl,
                      label: AdminLocalizations.translate(context, 'category name (arabic)'),
                      hint: AdminLocalizations.translate(context, 'e.g. electronics'),
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
                      hint: AdminLocalizations.translate(context, 'e.g. items related to consumer electronics'),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: AppTextField(
                      controller: _descArCtrl,
                      label: AdminLocalizations.translate(context, 'description (arabic)'),
                      hint: AdminLocalizations.translate(context, 'e.g. consumer electronics (arabic)'),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: AppTextField(
                      controller: _codeCtrl,
                      label: AdminLocalizations.translate(context, 'code'),
                      hint: AdminLocalizations.translate(context, 'e.g. elec'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: categoryTreeAsync.when(
                    data: (tree) {
                      final items = _buildDropdownItems(tree);
                      return CategoryTreeDropdown(
                        label: AdminLocalizations.translate(context, 'parent category'),
                        hint: AdminLocalizations.translate(context, 'none'),
                        value: _parentId,
                        items: items,
                        onChanged: (val) {
                          setState(() {
                            _parentId = (val == 0) ? null : val;
                          });
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, _) => Text(AdminLocalizations.translate(context, 'error loading categories')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AdminImagePicker(
              label: AdminLocalizations.translate(context, 'category image'),
              initialImage: widget.initial?.imageUrl,
              uploadProgress: widget.uploadProgress,
              onImageSelected: (file) => setState(() => _imageFile = file),
              onRemoveInitial: () => setState(() => _removeInitialImage = true),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: Text(AdminLocalizations.translate(context, 'has children'), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(AdminLocalizations.translate(context, 'allow subcategories under this category')),
              value: _hasChildren,
              onChanged: (v) => setState(() => _hasChildren = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
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
              child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'add category') : AdminLocalizations.translate(context, 'save changes')),
            ),
          ],
        ),
      ),
    );
  }
}
