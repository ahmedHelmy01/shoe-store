import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';

class WarehouseForm extends StatefulWidget {
  final WarehouseRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const WarehouseForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<WarehouseForm> createState() => _WarehouseFormState();
}

class _WarehouseFormState extends State<WarehouseForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _locationCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _locationCtrl = TextEditingController(text: widget.initial?.location ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSave({
      'name': _nameCtrl.text.trim(),
      'location': _locationCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _nameCtrl,
          label: 'Warehouse Name',
          hint: 'e.g. Main Distribution Center',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _locationCtrl,
          label: 'Address',
          hint: 'Warehouse physical location...',
          borderRadius: 14,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? 'Create Warehouse' : 'Save Changes'),
        ),
      ],
    );
  }
}
