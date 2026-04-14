import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';

class OrderForm extends StatefulWidget {
  final OrderRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const OrderForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  late final TextEditingController _statusCtrl;

  @override
  void initState() {
    super.initState();
    _statusCtrl = TextEditingController(text: widget.initial?.status ?? '');
  }

  @override
  void dispose() {
    _statusCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'status': _statusCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _statusCtrl,
          label: 'Order Status',
          hint: 'e.g. Pending, Delivered, Cancelled',
          borderRadius: 14,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? 'Process Order' : 'Update Status'),
        ),
      ],
    );
  }
}
