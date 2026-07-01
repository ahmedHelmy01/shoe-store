import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/models/order_status_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class OrderForm extends StatefulWidget {
  final OrderRow? initial;
  final bool isSaving;
  final List<OrderStatusRow> statuses;
  final void Function(Map<String, dynamic> data) onSave;

  const OrderForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.statuses,
    required this.onSave,
  });

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  int? _selectedStatusId;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _notesCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant OrderForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statuses != oldWidget.statuses && _selectedStatusId == null && widget.statuses.isNotEmpty) {
      final matched = widget.initial != null
          ? widget.statuses.where((s) => s.name.toLowerCase() == widget.initial!.status.toLowerCase()).firstOrNull
          : null;
      _selectedStatusId = matched?.id ?? widget.statuses.first.id;
    }
  }

  void _submit() {
    if (_selectedStatusId == null) return;
    widget.onSave({
      'order_status_id': _selectedStatusId,
      if (_notesCtrl.text.trim().isNotEmpty) 'notes': _notesCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropdown<int>(
          label: AdminLocalizations.translate(context, 'order status'),
          hint: AdminLocalizations.translate(context, 'select status'),
          value: _selectedStatusId,
          borderRadius: 14,
          items: widget.statuses.map((s) {
            final color = _parseColor(s.color);
            return DropdownMenuItem<int>(
              value: s.id,
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(AdminLocalizations.translateStatus(context, s.name)),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedStatusId = val),
        ),
        const SizedBox(height: 20),
        AppTextField(
          controller: _notesCtrl,
          label: AdminLocalizations.translate(context, 'notes'),
          hint: AdminLocalizations.translate(context, 'order is being prepared'),
          maxLines: 3,
          borderRadius: 14,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(AdminLocalizations.translate(context, 'update status')),
        ),
      ],
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
