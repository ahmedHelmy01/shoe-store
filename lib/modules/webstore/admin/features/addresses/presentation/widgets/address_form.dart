import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/models/address_row.dart';
import 'package:erp/modules/webstore/admin/features/governorates/presentation/view_model/governorates_view_model.dart';
import 'package:erp/modules/webstore/admin/features/cities/presentation/view_model/cities_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';

class AddressForm extends ConsumerStatefulWidget {
  final AddressRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const AddressForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  ConsumerState<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<AddressForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _addressDetailsCtrl;
  
  int? _selectedGovernorateId;
  int? _selectedCityId;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _mobileCtrl = TextEditingController(text: widget.initial?.mobile ?? '');
    _addressDetailsCtrl = TextEditingController(text: widget.initial?.addressDetails ?? '');
    _selectedGovernorateId = widget.initial?.governorateId;
    _selectedCityId = widget.initial?.cityId;
    _isDefault = widget.initial?.isDefault ?? false;

    // Fetch governorates and cities on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(governoratesVmProvider.notifier).fetch();
      ref.read(citiesVmProvider.notifier).fetch();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _addressDetailsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'name': _nameCtrl.text.trim(),
        'mobile': _mobileCtrl.text.trim(),
        'address_details': _addressDetailsCtrl.text.trim(),
        'governorate_id': _selectedGovernorateId,
        'city_id': _selectedCityId,
        'is_default': _isDefault,
      };
      widget.onSave(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final governoratesState = ref.watch(governoratesVmProvider);
    final citiesState = ref.watch(citiesVmProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _nameCtrl,
            label: 'Name',
            hint: 'e.g. Home, Office',
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _mobileCtrl,
            label: 'Mobile Number',
            hint: '966500000000',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _addressDetailsCtrl,
            label: 'Address Details',
            hint: 'Block 1, Street 2...',
            maxLines: 2,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppDropdown<int>(
                  label: 'Governorate',
                  hint: 'Select Governorate',
                  value: _selectedGovernorateId,
                  items: _buildGovernorateItems(governoratesState),
                  onChanged: (val) {
                    setState(() {
                      _selectedGovernorateId = val;
                      _selectedCityId = null; // Reset city when governorate changes
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDropdown<int>(
                  label: 'City',
                  hint: 'Select City',
                  value: _selectedCityId,
                  items: _buildCityItems(citiesState),
                  onChanged: (val) => setState(() => _selectedCityId = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Set as Default'),
            value: _isDefault,
            onChanged: (v) => setState(() => _isDefault = v),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? 'Add Address' : 'Save Changes'),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildGovernorateItems(AdminCrudState governoratesState) {
    if (governoratesState is! AdminCrudData) return [];
    return governoratesState.items.map((g) {
      return DropdownMenuItem<int>(
        value: g.id,
        child: Text(g.name),
      );
    }).toList();
  }

  List<DropdownMenuItem<int>> _buildCityItems(AdminCrudState citiesState) {
    if (citiesState is! AdminCrudData) return [];
    
    // Filter cities by governorate if selected
    final items = _selectedGovernorateId != null
        ? citiesState.items.where((c) => c.governorateId == _selectedGovernorateId)
        : citiesState.items;

    return items.map((c) {
      return DropdownMenuItem<int>(
        value: c.id,
        child: Text(c.name),
      );
    }).toList();
  }
}
