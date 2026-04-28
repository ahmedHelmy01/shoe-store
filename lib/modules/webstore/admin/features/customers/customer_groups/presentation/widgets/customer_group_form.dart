import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/customers/customer_groups/data/models/customer_group_row.dart';

class CustomerGroupForm extends StatefulWidget {
  final CustomerGroupRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const CustomerGroupForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<CustomerGroupForm> createState() => _CustomerGroupFormState();
}

class _CustomerGroupFormState extends State<CustomerGroupForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _titleArCtrl;
  bool _isDefault = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _titleArCtrl = TextEditingController(text: widget.initial?.titleAr ?? '');
    _isDefault = widget.initial?.isDefault ?? false;
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _titleArCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'title': _titleCtrl.text.trim(),
        'title_ar': _titleArCtrl.text.trim(),
        'parent_id': null, // Simplified for now
        'is_default': _isDefault,
        'is_active': _isActive,
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
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _titleCtrl,
                  label: 'Title (EN)',
                  hint: 'e.g. VIP Customers',
                  borderRadius: 14,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _titleArCtrl,
                  label: 'Title (AR)',
                  hint: 'مثال: عملاء مميزون',
                  borderRadius: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SwitchListTile(
            title: const Text('Default Group', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('New customers will be assigned to this group by default'),
            value: _isDefault,
            onChanged: (v) => setState(() => _isDefault = v),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Active', style: TextStyle(fontWeight: FontWeight.bold)),
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? 'Create Group' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
