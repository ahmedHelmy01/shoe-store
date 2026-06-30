import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/features/countries/presentation/view_model/countries_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/countries/data/models/country_row.dart';

class GovernorateForm extends ConsumerStatefulWidget {
  final GovernorateRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const GovernorateForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  ConsumerState<GovernorateForm> createState() => _GovernorateFormState();
}

class _GovernorateFormState extends ConsumerState<GovernorateForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late bool _isActive;
  int? _selectedCountryId;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.nameEn ?? widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _isActive = widget.initial?.isActive ?? true;
    _selectedCountryId = widget.initial?.countryId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedCountryId == null && widget.initial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AdminLocalizations.translate(context, 'please select a country'))),
      );
      return;
    }

    widget.onSave({
      if (_selectedCountryId != null) 'country_id': _selectedCountryId,
      'name': _nameCtrl.text.trim(),
      'name_en': _nameCtrl.text.trim(),
      'name_ar': _nameArCtrl.text.trim(),
      'is_active': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    final countriesState = ref.watch(countriesViewModelProvider);
    final items = countriesState is AdminCrudData<CountryRow> ? countriesState.items : <CountryRow>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDropdown<int>(
          label: AdminLocalizations.translate(context, 'country'),
          hint: AdminLocalizations.translate(context, 'select country'),
          value: _selectedCountryId,
          items: items.map((c) => DropdownMenuItem<int>(
            value: c.id,
            child: Text(c.name),
          )).toList(),
          onChanged: (val) => setState(() => _selectedCountryId = val),
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _nameCtrl,
          label: AdminLocalizations.translate(context, 'governorate name (en)'),
          hint: AdminLocalizations.translate(context, 'e.g. cairo'),
          borderRadius: 14,
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _nameArCtrl,
          label: AdminLocalizations.translate(context, 'governorate name (ar)'),
          hint: 'مثلاً القاهرة',
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
          child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'create governorate') : AdminLocalizations.translate(context, 'save changes')),
        ),
      ],
    );
  }
}
