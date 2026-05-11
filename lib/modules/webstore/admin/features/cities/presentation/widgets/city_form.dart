import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/cities/data/models/city_row.dart';
import 'package:erp/modules/webstore/admin/features/governorates/presentation/view_model/governorates_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';

class CityForm extends ConsumerStatefulWidget {
  final CityRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const CityForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  ConsumerState<CityForm> createState() => _CityFormState();
}

class _CityFormState extends ConsumerState<CityForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _deliveryFeeCtrl;
  late bool _isActive;
  int? _selectedGovId;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _deliveryFeeCtrl = TextEditingController(text: widget.initial?.deliveryFee?.toString() ?? '0');
    _isActive = widget.initial?.isActive ?? true;
    _selectedGovId = widget.initial?.governorateId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _deliveryFeeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedGovId == null && widget.initial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a governorate')),
      );
      return;
    }

    final fee = double.tryParse(_deliveryFeeCtrl.text) ?? 0;

    widget.onSave({
      if (_selectedGovId != null) 'governorate_id': _selectedGovId,
      'name': _nameCtrl.text.trim(),
      'name_ar': _nameArCtrl.text.trim(),
      'shipping_cost': fee, // Strictly using shipping_cost as confirmed
      'is_active': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    final govState = ref.watch(governoratesVmProvider);
    final items = govState is AdminCrudData<GovernorateRow> ? govState.items : <GovernorateRow>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropdown<int>(
          label: 'Governorate',
          hint: 'Select Governorate',
          value: _selectedGovId,
          items: items.map((g) => DropdownMenuItem<int>(
            value: g.id,
            child: Text(g.name),
          )).toList(),
          onChanged: (val) => setState(() => _selectedGovId = val),
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _nameCtrl,
          label: 'City Name (EN)',
          hint: 'e.g. Hawalli',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _nameArCtrl,
          label: 'City Name (AR)',
          hint: 'مثلاً حولي',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _deliveryFeeCtrl,
          label: 'Delivery Fee',
          hint: '1.5',
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
          child: Text(widget.initial == null ? 'Create City' : 'Save Changes'),
        ),
      ],
    );
  }
}
