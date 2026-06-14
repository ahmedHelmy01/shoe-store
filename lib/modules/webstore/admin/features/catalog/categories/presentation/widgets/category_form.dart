import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/category_tree_dropdown.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';

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
    _parentId = widget.initial?.parentId;
    _isActive = widget.initial?.isActive ?? true;
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
    final result = <CategoryTreeItem>[];
    
    // Add "None" option first
    result.add(const CategoryTreeItem(id: 0, name: 'None (لا يوجد)', isChild: false));
    
    for (final cat in tree) {
      final map = cat as Map<String, dynamic>;
      final id = map['id'] as int;
      
      // If this top-level category is the one we are editing, we skip the entire branch!
      if (widget.initial != null && id == widget.initial!.id) {
        continue;
      }
      
      final name = (map['name'] ?? map['name_ar'] ?? map['name_en'] ?? 'بدون اسم').toString();
      result.add(CategoryTreeItem(id: id, name: name, isChild: false));

      final children = map['children'] as List?;
      if (children != null) {
        for (final child in children) {
          final childMap = child as Map<String, dynamic>;
          final childId = childMap['id'] as int;
          
          // If this child category is the one we are editing, we skip it
          if (widget.initial != null && childId == widget.initial!.id) {
            continue;
          }
          
          final childName = (childMap['name'] ?? childMap['name_ar'] ?? childMap['name_en'] ?? 'بدون اسم').toString();
          result.add(CategoryTreeItem(id: childId, name: childName, isChild: true));
        }
      }
    }
    return result;
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
            AppTextField(
              controller: _descCtrl,
              label: 'Description (English)',
              hint: 'e.g. Items related to consumer electronics',
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _descArCtrl,
              label: 'Description (Arabic)',
              hint: 'e.g. الأجهزة والمعدات الإلكترونية الاستهلاكية',
              maxLines: 2,
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
                  child: categoryTreeAsync.when(
                    data: (tree) {
                      final items = _buildDropdownItems(tree);
                      return CategoryTreeDropdown(
                        label: 'Parent Category',
                        hint: 'None (لا يوجد)',
                        value: items.any((c) => c.id == _parentId) ? _parentId : null,
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
                    error: (e, _) => const Text('Error loading categories'),
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
