import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
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
  late final TextEditingController _descCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _descCtrl = TextEditingController(text: widget.initial?.description ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'name': _nameCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'is_active': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _nameCtrl,
          label: 'Method Name',
          hint: 'e.g. Credit Card, PayPal',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _descCtrl,
          label: 'Instructions',
          hint: 'Payment details for the user...',
          maxLines: 3,
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
