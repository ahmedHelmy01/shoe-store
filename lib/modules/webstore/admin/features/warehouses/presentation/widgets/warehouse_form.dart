import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';
import 'package:erp/modules/webstore/admin/features/branches/presentation/view_model/branches_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';

class WarehouseForm extends ConsumerStatefulWidget {
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
  ConsumerState<WarehouseForm> createState() => _WarehouseFormState();
}

class _WarehouseFormState extends ConsumerState<WarehouseForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _phoneCtrl;
  late bool _isActive;
  int? _selectedBranchId;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _codeCtrl = TextEditingController(text: widget.initial?.code ?? '');
    _addressCtrl = TextEditingController(text: widget.initial?.location ?? '');
    _phoneCtrl = TextEditingController(text: widget.initial?.phone ?? '');
    _isActive = widget.initial?.isActive ?? true;
    _selectedBranchId = widget.initial?.branchId;
    Future.microtask(() => ref.read(branchesVmProvider.notifier).fetch(page: 1));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _codeCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    widget.onSave({
      'name': _nameCtrl.text.trim(),
      if (_nameArCtrl.text.trim().isNotEmpty) 'name_ar': _nameArCtrl.text.trim(),
      if (_codeCtrl.text.trim().isNotEmpty) 'code': _codeCtrl.text.trim(),
      if (_selectedBranchId != null) 'branch_id': _selectedBranchId,
      if (_addressCtrl.text.trim().isNotEmpty) 'address': _addressCtrl.text.trim(),
      if (_phoneCtrl.text.trim().isNotEmpty) 'phone': _phoneCtrl.text.trim(),
      'is_active': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    final branchesState = ref.watch(branchesVmProvider);
    final branches = branchesState is AdminCrudData<BranchRow> ? branchesState.items : <BranchRow>[];

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _nameCtrl,
            label: 'Warehouse Name',
            hint: 'e.g. Main Warehouse',
            borderRadius: 14,
            validator: (value) {
              if ((value ?? '').trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _nameArCtrl,
            label: 'Warehouse Name (Arabic)',
            hint: 'e.g. المخزن الرئيسي',
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _codeCtrl,
            label: 'Code',
            hint: 'e.g. WH-001',
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          AppDropdown<int>(
            label: 'Branch',
            value: branches.any((b) => b.id == _selectedBranchId) ? _selectedBranchId : null,
            hint: branchesState is AdminCrudLoading<BranchRow>
                ? 'Loading branches...'
                : 'Select branch',
            enabled: branches.isNotEmpty && !widget.isSaving,
            onChanged: (value) => setState(() => _selectedBranchId = value),
            items: branches
                .map(
                  (branch) => DropdownMenuItem<int>(
                    value: branch.id,
                    child: Text(branch.name),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _addressCtrl,
            label: 'Address',
            hint: 'Warehouse address',
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _phoneCtrl,
            label: 'Phone',
            hint: 'e.g. 01000000000',
            keyboardType: TextInputType.phone,
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
            contentPadding: EdgeInsets.zero,
            title: const Text('Active'),
            subtitle: Text(
              _isEdit
                  ? 'Update active status for this warehouse'
                  : 'Set initial active status',
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(_isEdit ? 'Save Changes' : 'Create Warehouse'),
          ),
        ],
      ),
    );
  }
}
