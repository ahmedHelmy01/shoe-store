import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/models/payment_status_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class PaymentStatusForm extends StatefulWidget {
  final PaymentStatusRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const PaymentStatusForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<PaymentStatusForm> createState() => _PaymentStatusFormState();
}

class _PaymentStatusFormState extends State<PaymentStatusForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _sortOrderCtrl;
  late bool _isActive;

  static const _presetColors = [
    Color(0xFF4CAF50), // green
    Color(0xFFF44336), // red
    Color(0xFFFF9800), // orange
    Color(0xFF2196F3), // blue
    Color(0xFF9C27B0), // purple
    Color(0xFF607D8B), // grey
    Color(0xFFE91E63), // pink
    Color(0xFF009688), // teal
    Color(0xFF795548), // brown
    Color(0xFF3F51B5), // indigo
  ];

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _nameCtrl = TextEditingController(text: i?.nameEn ?? i?.name ?? '');
    _nameArCtrl = TextEditingController(text: i?.nameAr ?? '');
    _sortOrderCtrl = TextEditingController(text: i?.sortOrder.toString() ?? '0');
    _isActive = i?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _sortOrderCtrl.dispose();
    super.dispose();
  }

  String _colorToHex(Color c) {
    return '#${c.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  void _submit() {
    widget.onSave({
      'name': _nameCtrl.text.trim(),
      'name_en': _nameCtrl.text.trim(),
      'name_ar': _nameArCtrl.text.trim(),
      'sort_order': int.tryParse(_sortOrderCtrl.text.trim()) ?? 0,
      'is_active': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _nameCtrl,
                label: AdminLocalizations.translate(context, 'name (english)'),
                hint: AdminLocalizations.translate(context, 'e.g. paid, pending'),
                borderRadius: 14,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: _nameArCtrl,
                label: AdminLocalizations.translate(context, 'name (arabic)'),
                hint: 'مثال: مدفوع, معلق',
                borderRadius: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _sortOrderCtrl,
          label: AdminLocalizations.translate(context, 'sort order'),
          hint: '0',
          keyboardType: TextInputType.number,
          borderRadius: 14,
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: Text(AdminLocalizations.translate(context, 'is active')),
          subtitle: Text(AdminLocalizations.translate(context, 'enable or disable this payment status')),
          value: _isActive,
          onChanged: (v) => setState(() => _isActive = v),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'create payment status') : AdminLocalizations.translate(context, 'save changes')),
        ),
      ],
    );
  }
}
