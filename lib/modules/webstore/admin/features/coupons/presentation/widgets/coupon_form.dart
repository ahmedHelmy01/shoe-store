import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';

class CouponForm extends StatefulWidget {
  final CouponRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const CouponForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<CouponForm> createState() => _CouponFormState();
}

class _CouponFormState extends State<CouponForm> {
  late final TextEditingController _codeCtrl;
  late final TextEditingController _discountCtrl;
  bool _isPercentage = true;

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController(text: widget.initial?.code ?? '');
    _discountCtrl = TextEditingController(text: widget.initial?.discountAmount?.toString() ?? '');
    _isPercentage = widget.initial?.isPercentage ?? true;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _discountCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'code': _codeCtrl.text.trim().toUpperCase(),
      'discountAmount': double.tryParse(_discountCtrl.text.trim()) ?? 0.0,
      'isPercentage': _isPercentage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _codeCtrl,
          label: 'Coupon Code',
          hint: 'e.g. SUMMER24',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _discountCtrl,
          label: 'Discount Value',
          hint: '0.0',
          keyboardType: TextInputType.number,
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        SwitchListTile(
          title: const Text('Is Percentage?'),
          value: _isPercentage,
          onChanged: (v) => setState(() => _isPercentage = v),
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? 'Create Coupon' : 'Save Changes'),
        ),
      ],
    );
  }
}
