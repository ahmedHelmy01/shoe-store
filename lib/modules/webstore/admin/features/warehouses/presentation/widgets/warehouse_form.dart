import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';
import 'package:erp/modules/webstore/admin/features/branches/presentation/view_model/branches_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';
import '../view_model/warehouses_view_model.dart';

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
  late final TextEditingController _notesCtrl;
  late bool _isActive;
  int? _selectedBranchId;
  int? _selectedParentId;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _codeCtrl = TextEditingController(text: widget.initial?.code ?? '');
    _addressCtrl = TextEditingController(text: widget.initial?.location ?? '');
    _phoneCtrl = TextEditingController(text: widget.initial?.phone ?? '');
    _notesCtrl = TextEditingController(text: widget.initial?.notes ?? '');
    _isActive = widget.initial?.isActive ?? true;
    _selectedBranchId = widget.initial?.branchId;
    _selectedParentId = (widget.initial?.parentWarehouseId == 0) ? null : widget.initial?.parentWarehouseId;
    Future.microtask(() => ref.read(branchesVmProvider.notifier).fetch(page: 1));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _codeCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
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
      'parent_warehouse_id': _selectedParentId ?? 0,
      'notes': _notesCtrl.text.trim(),
      'is_active': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    final branchesState = ref.watch(branchesVmProvider);
    final branches = branchesState is AdminCrudData<BranchRow> ? branchesState.items : <BranchRow>[];

    final warehousesState = ref.watch(warehousesVmProvider);
    final warehouses = warehousesState is AdminCrudData<WarehouseRow> ? warehousesState.items : <WarehouseRow>[];
    final parentOptions = widget.initial != null
        ? warehouses.where((w) => w.id != widget.initial!.id).toList()
        : warehouses;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
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
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _nameArCtrl,
                  label: 'Warehouse Name (Arabic)',
                  hint: 'e.g. المخزن الرئيسي',
                  borderRadius: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _codeCtrl,
                  label: 'Code',
                  hint: 'e.g. WH-001',
                  borderRadius: 14,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDropdown<int>(
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
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _addressCtrl,
                  label: 'Address',
                  hint: 'Warehouse address',
                  borderRadius: 14,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _phoneCtrl,
                  label: 'Phone',
                  hint: 'e.g. 01000000000',
                  keyboardType: TextInputType.phone,
                  borderRadius: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppDropdown<int>(
                  label: 'Parent Warehouse',
                  value: parentOptions.any((w) => w.id == _selectedParentId) ? _selectedParentId : null,
                  hint: 'None (لا يوجد)',
                  onChanged: (value) => setState(() => _selectedParentId = value),
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text('None (لا يوجد)'),
                    ),
                    ...parentOptions.map(
                      (w) => DropdownMenuItem<int>(
                        value: w.id,
                        child: Text(w.name),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _notesCtrl,
                  label: 'Notes',
                  hint: 'Warehouse notes',
                  borderRadius: 14,
                ),
              ),
            ],
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
