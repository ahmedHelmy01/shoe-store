import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';

class CategoryForm extends StatefulWidget {
  final CategoryRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const CategoryForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _parentCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _parentCtrl = TextEditingController(text: widget.initial?.parentId?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _parentCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'name': _nameCtrl.text.trim(),
        'parentId': int.tryParse(_parentCtrl.text.trim()),
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
            label: 'Category Name',
            hint: 'e.g. Electronics',
            validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _parentCtrl,
            label: 'Parent Category ID',
            hint: 'Optional',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? 'Add Category' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
