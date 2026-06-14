import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_dropdown/category_tree_dropdown.dart';
import 'package:erp/core/common_widget/app_dropdown/app_multi_dropdown.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';
import 'package:erp/core/network/network_url.dart';

class ProductForm extends ConsumerStatefulWidget {
  final ProductRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data, XFile? imageFile, List<XFile>? galleryFiles) onSave;

  const ProductForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  ConsumerState<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _nameEnCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _salePriceCtrl;
  late final TextEditingController _purchasePriceCtrl;
  late final TextEditingController _descArCtrl;
  late final TextEditingController _descEnCtrl;
  
  int? _selectedCategoryId;
  int? _selectedCompanyId;
  List<int> _selectedTagIds = [];
  List<int> _selectedPropertyIds = [];
  
  bool _isActive = true;
  XFile? _imageFile;
  List<XFile> _galleryFiles = [];
  // Removed _uploadedImagePath and _uploadedGalleryPaths as we now use direct file upload
  bool _removeInitialImage = false;

  @override
  void initState() {
    super.initState();
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _nameEnCtrl = TextEditingController(text: widget.initial?.nameEn ?? '');
    _skuCtrl = TextEditingController(text: widget.initial?.sku ?? '');
    _salePriceCtrl = TextEditingController(text: widget.initial?.salePrice ?? '');
    _purchasePriceCtrl = TextEditingController(text: widget.initial?.purchasePrice ?? '');
    _descArCtrl = TextEditingController(text: widget.initial?.descriptionAr ?? '');
    _descEnCtrl = TextEditingController(text: widget.initial?.description ?? '');
    
    _selectedCategoryId = widget.initial?.productCategoryId;
    _selectedCompanyId = widget.initial?.companyId;
    _selectedTagIds = widget.initial?.tags?.map((e) => e.id).toList() ?? [];
    _selectedPropertyIds = widget.initial?.properties?.map((e) => e.id).toList() ?? [];
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void didUpdateWidget(covariant ProductForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initial != oldWidget.initial && widget.initial != null) {
      setState(() {
        _selectedTagIds = widget.initial!.tags?.map((e) => e.id).toList() ?? [];
        _selectedPropertyIds = widget.initial!.properties?.map((e) => e.id).toList() ?? [];
      });
    }
  }

  @override
  void dispose() {
    _nameArCtrl.dispose();
    _nameEnCtrl.dispose();
    _skuCtrl.dispose();
    _salePriceCtrl.dispose();
    _purchasePriceCtrl.dispose();
    _descArCtrl.dispose();
    _descEnCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{
        'name_ar': _nameArCtrl.text.trim(),
        'name_en': _nameEnCtrl.text.trim(),
        'name': _nameEnCtrl.text.trim(),
        'sku': _skuCtrl.text.trim(),
        'sale_price': _salePriceCtrl.text.trim(),
        'purchase_price': _purchasePriceCtrl.text.trim(),
        'description_ar': _descArCtrl.text.trim(),
        'description': _descEnCtrl.text.trim(),
        'product_category_id': _selectedCategoryId,
        'manufacturer_id': _selectedCompanyId,
        'tags': _selectedTagIds,
        'properties': _selectedPropertyIds,
        'is_active': _isActive ? 1 : 0,
      };

      if (_removeInitialImage && _imageFile == null) {
        data['image'] = '';
      } else if (_imageFile == null && widget.initial?.image != null) {
        // Keep existing image path if not changed or removed
        data['image'] = widget.initial!.image;
      }

      // Handle Gallery - filter out any deleted initial images and send remaining paths
      if (widget.initial?.images != null) {
        final remainingUrls = widget.initial!.imageUrls ?? [];
        final remainingPaths = <String>[];
        for (final path in widget.initial!.images!) {
          final fullUrl = NetworkUrl.fullUrl(path);
          if (remainingUrls.contains(fullUrl)) {
            remainingPaths.add(path);
          }
        }
        data['images'] = remainingPaths;
      }

      widget.onSave(data, _imageFile, _galleryFiles.isEmpty ? null : _galleryFiles);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryTreeAsync = ref.watch(categoryTreeProvider);
    final companiesAsync = ref.watch(allCompaniesProvider);
    final tagsAsync = ref.watch(allTagsProvider);
    final propertiesAsync = ref.watch(allPropertiesProvider);

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
                    controller: _nameArCtrl,
                    label: 'Name (Arabic)',
                    hint: 'اسم المنتج بالعربي',
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _nameEnCtrl,
                    label: 'Name (English)',
                    hint: 'Product name in English',
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _skuCtrl,
                    label: 'SKU / Barcode',
                    hint: 'e.g. SKU-12345',
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: categoryTreeAsync.when(
                    data: (tree) {
                      final items = CategoryTreeDropdown.flattenTree(tree);
                      return CategoryTreeDropdown(
                        label: 'Category',
                        hint: 'Select Category',
                        value: items.any((c) => c.id == _selectedCategoryId) ? _selectedCategoryId : null,
                        items: items,
                        onChanged: (v) => setState(() => _selectedCategoryId = v),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => const Text('Error loading categories'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            companiesAsync.when(
              data: (list) => AppDropdown<int>(
                label: 'Company / Manufacturer',
                hint: 'Select Company',
                value: list.any((c) => c.id == _selectedCompanyId) ? _selectedCompanyId : null,
                items: list.map((c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c.name),
                )).toList(),
                onChanged: (v) => setState(() => _selectedCompanyId = v),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Text('Error loading companies'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _purchasePriceCtrl,
                    label: 'Purchase Price',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _salePriceCtrl,
                    label: 'Sale Price',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _descArCtrl,
              label: 'Description (Arabic)',
              hint: 'وصف المنتج بالعربي...',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _descEnCtrl,
              label: 'Description (English)',
              hint: 'Product description in English...',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: tagsAsync.when(
                    data: (list) => AppMultiDropdown<int>(
                      label: 'Tags',
                      hint: 'Select Tags',
                      selectedValues: _selectedTagIds,
                      items: list.map((t) => DropdownMenuItem(
                        value: t.id,
                        child: Text(t.nameAr ?? t.name),
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedTagIds = v),
                    ),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    ),
                    error: (e, _) => const Text('Error loading tags'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: propertiesAsync.when(
                    data: (list) => AppMultiDropdown<int>(
                      label: 'Properties',
                      hint: 'Select Properties',
                      selectedValues: _selectedPropertyIds,
                      items: list.map((p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.titleAr ?? p.title),
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedPropertyIds = v),
                    ),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    ),
                    error: (e, _) => const Text('Error loading properties'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: AdminImagePicker(
                      label: 'Product Image',
                      initialImage: widget.initial?.imageUrl,
                      onImageSelected: (file) => setState(() => _imageFile = file),
                      onRemoveInitial: () => setState(() => _removeInitialImage = true),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: AdminImagePicker(
                      label: 'Gallery Images',
                      isMultiple: true,
                      initialGallery: widget.initial?.imageUrls,
                      onGallerySelected: (files) => setState(() => _galleryFiles = files),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Is Active'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: _submit,
              isLoading: widget.isSaving,
              child: Text(widget.initial == null ? 'Add Product' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
