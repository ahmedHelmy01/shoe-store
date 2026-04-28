import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';

class PaymentMethodForm extends StatefulWidget {
  final PaymentMethodRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const PaymentMethodForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<PaymentMethodForm> createState() => _PaymentMethodFormState();
}

class _PaymentMethodFormState extends State<PaymentMethodForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _noteCtrl;
  late final TextEditingController _noteArCtrl;
  late final TextEditingController _sortOrderCtrl;
  late String _type;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _nameCtrl = TextEditingController(text: i?.name ?? '');
    _nameArCtrl = TextEditingController(text: i?.nameAr ?? '');
    _noteCtrl = TextEditingController(text: i?.note ?? '');
    _noteArCtrl = TextEditingController(text: i?.noteAr ?? '');
    _sortOrderCtrl = TextEditingController(text: i?.sortOrder.toString() ?? '0');
    _type = i?.type ?? 'cod';
    _isActive = i?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _noteCtrl.dispose();
    _noteArCtrl.dispose();
    _sortOrderCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'name': _nameCtrl.text.trim(),
      'name_ar': _nameArCtrl.text.trim(),
      'type': 'cod',
      'note': _noteCtrl.text.trim(),
      'note_ar': _noteArCtrl.text.trim(),
      'sort_order': int.tryParse(_sortOrderCtrl.text.trim()) ?? 0,
      'is_active': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _nameCtrl,
                label: 'Name (English)',
                hint: 'e.g. Credit Card',
                borderRadius: 14,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: _nameArCtrl,
                label: 'Name (Arabic)',
                hint: 'مثال: بطاقة ائتمان',
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
                controller: _noteCtrl,
                label: 'Note (English)',
                hint: 'e.g. Additional fees apply',
                borderRadius: 14,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: _noteArCtrl,
                label: 'Note (Arabic)',
                hint: 'مثال: تطبق رسوم إضافية',
                borderRadius: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _sortOrderCtrl,
          label: 'Sort Order',
          hint: '0',
          keyboardType: TextInputType.number,
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
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
          child: Text(widget.initial == null ? 'Create Method' : 'Save Changes'),
        ),
      ],
    );
  }
}
