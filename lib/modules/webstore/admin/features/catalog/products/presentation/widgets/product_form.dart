import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';

class ProductForm extends StatefulWidget {
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
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _skuCtrl = TextEditingController(text: widget.initial?.sku ?? '');
    _priceCtrl = TextEditingController(text: widget.initial?.price?.toString() ?? '');
    _descCtrl = TextEditingController(text: widget.initial?.description ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _skuCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'name': _nameCtrl.text.trim(),
        'sku': _skuCtrl.text.trim(),
        'price': double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
        'description': _descCtrl.text.trim(),
      });
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
            label: 'Product Name',
            hint: 'e.g. iPhone 15 Pro',
            validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _skuCtrl,
            label: 'SKU / Barcode',
            hint: 'e.g. APP-IP15P-BK',
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _priceCtrl,
            label: 'Initial Price',
            hint: '0.00',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _descCtrl,
            label: 'Description',
            hint: 'Full product details...',
            maxLines: 4,
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
