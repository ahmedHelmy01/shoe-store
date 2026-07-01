import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/models/order_status_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
        'name_ar': _nameArCtrl.text.trim(),
        'color': _colorCtrl.text.trim(),
        'sort_order': int.tryParse(_sortOrderCtrl.text) ?? 1,
        'is_default': _isDefault,
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
                    label: AdminLocalizations.translate(context, 'status name (en)'),
                    hint: AdminLocalizations.translate(context, 'e.g. processing'),
                    borderRadius: 14,
                    validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'required') : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _nameArCtrl,
                    label: AdminLocalizations.translate(context, 'status name (ar)'),
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
                    label: AdminLocalizations.translate(context, 'color (hex)'),
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
                    label: AdminLocalizations.translate(context, 'sort order'),
                    hint: '1',
                    borderRadius: 14,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SwitchListTile(
              title: Text(AdminLocalizations.translate(context, 'default status'), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(AdminLocalizations.translate(context, 'new orders will start with this status')),
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: Text(AdminLocalizations.translate(context, 'active'), style: const TextStyle(fontWeight: FontWeight.bold)),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: _submit,
              isLoading: widget.isSaving,
              child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'create status') : AdminLocalizations.translate(context, 'save changes')),
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
