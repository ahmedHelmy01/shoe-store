import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';

class ProductForm extends ConsumerStatefulWidget {
  final ProductRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

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
      widget.onSave({
        'name_ar': _nameArCtrl.text.trim(),
        'name_en': _nameEnCtrl.text.trim(),
        'name': _nameEnCtrl.text.trim(),
        'sku': _skuCtrl.text.trim(),
        'sale_price': _salePriceCtrl.text.trim(),
        'purchase_price': _purchasePriceCtrl.text.trim(),
        'description_ar': _descArCtrl.text.trim(),
        'description': _descEnCtrl.text.trim(),
        'product_category_id': _selectedCategoryId,
        'manufacturer_id': _selectedCompanyId, // Using manufacturer_id as requested
        'is_active': (widget.initial?.isActive ?? true) ? 1 : 0, // Convert to 1/0
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final companiesAsync = ref.watch(allCompaniesProvider);

    return Form(
      key: _formKey,
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
                child: categoriesAsync.when(
                  data: (list) => AppDropdown<int>(
                    label: 'Category',
                    hint: 'Select Category',
                    value: list.any((c) => c.id == _selectedCategoryId) ? _selectedCategoryId : null,
                    items: list.map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error loading categories'),
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
            error: (e, _) => Text('Error loading companies'),
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
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? 'Add Product' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}

