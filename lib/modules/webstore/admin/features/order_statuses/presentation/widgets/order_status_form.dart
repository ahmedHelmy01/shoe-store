import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/models/order_status_row.dart';

class OrderStatusForm extends StatefulWidget {
  final OrderStatusRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const OrderStatusForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<OrderStatusForm> createState() => _OrderStatusFormState();
}

class _OrderStatusFormState extends State<OrderStatusForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _colorCtrl;
  late final TextEditingController _sortOrderCtrl;
  bool _isDefault = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.displayNameEn ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.displayNameAr ?? '');
    _colorCtrl = TextEditingController(text: widget.initial?.color ?? '#6366f1');
    _sortOrderCtrl = TextEditingController(text: '${widget.initial?.sortOrder ?? 1}');
    _isDefault = widget.initial?.isDefault ?? false;
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _colorCtrl.dispose();
    _sortOrderCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'name': _nameCtrl.text.trim(),
        'name_en': _nameCtrl.text.trim(),
        'name_ar': _nameArCtrl.text.trim(),
        'color': _colorCtrl.text.trim(),
        'sort_order': int.tryParse(_sortOrderCtrl.text) ?? 1,
        'is_default': _isDefault,
        'is_active': _isActive,
      });
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
                    controller: _nameCtrl,
                    label: 'Status Name (EN)',
                    hint: 'e.g. Processing',
                    borderRadius: 14,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _nameArCtrl,
                    label: 'Status Name (AR)',
                    hint: 'مثال: قيد التجهيز',
                    borderRadius: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _colorCtrl,
                    label: 'Color (Hex)',
                    hint: '#6366f1',
                    borderRadius: 14,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _parseColor(_colorCtrl.text),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                    ),
                    onChanged: (v) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _sortOrderCtrl,
                    label: 'Sort Order',
                    hint: '1',
                    borderRadius: 14,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SwitchListTile(
              title: const Text('Default Status', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('New orders will start with this status'),
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
              child: Text(widget.initial == null ? 'Create Status' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      if (!hex.startsWith('#')) hex = '#$hex';
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }
}
