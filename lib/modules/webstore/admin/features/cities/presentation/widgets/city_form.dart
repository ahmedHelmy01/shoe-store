import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/cities/data/models/city_row.dart';
import 'package:erp/modules/webstore/admin/features/governorates/presentation/view_model/governorates_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
  late final TextEditingController _codeCtrl;
  late final TextEditingController _deliveryFeeCtrl;
  late bool _isActive;
  int? _selectedGovId;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.nameEn ?? widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _codeCtrl = TextEditingController(text: widget.initial?.code ?? '');
    _deliveryFeeCtrl = TextEditingController(text: widget.initial?.deliveryFee.toString() ?? '0');
    _isActive = widget.initial?.isActive ?? true;
    _selectedGovId = widget.initial?.governorateId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _codeCtrl.dispose();
    _deliveryFeeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedGovId == null && widget.initial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AdminLocalizations.translate(context, 'please select a governorate'))),
      );
      return;
    }

    final fee = double.tryParse(_deliveryFeeCtrl.text) ?? 0;

    widget.onSave({
      if (_selectedGovId != null) 'governorate_id': _selectedGovId,
      'name': _nameCtrl.text.trim(),
      'name_en': _nameCtrl.text.trim(),
      'name_ar': _nameArCtrl.text.trim(),
      'code': _codeCtrl.text.trim(),
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
          label: AdminLocalizations.translate(context, 'governorate'),
          hint: AdminLocalizations.translate(context, 'select governorate'),
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
          label: AdminLocalizations.translate(context, 'city name (en)'),
          hint: AdminLocalizations.translate(context, 'e.g. hawalli'),
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _nameArCtrl,
          label: AdminLocalizations.translate(context, 'city name (ar)'),
          hint: 'مثلاً حولي',
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _codeCtrl,
          label: AdminLocalizations.translate(context, 'code'),
          hint: AdminLocalizations.translate(context, 'e.g. cai'),
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _deliveryFeeCtrl,
          label: AdminLocalizations.translate(context, 'delivery fee'),
          hint: '1.5',
          keyboardType: TextInputType.number,
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        SwitchListTile(
          title: Text(AdminLocalizations.translate(context, 'is active')),
          value: _isActive,
          onChanged: (v) => setState(() => _isActive = v),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 32),
        AppButton(
          onPressed: _submit,
          isLoading: widget.isSaving,
          child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'create city') : AdminLocalizations.translate(context, 'save changes')),
        ),
      ],
    );
  }
}
