import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../view_model/filters_view_model.dart';

class FilterForm extends ConsumerStatefulWidget {
  final FilterRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

  const FilterForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  ConsumerState<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends ConsumerState<FilterForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _colorCtrl;
  int? _selectedParentId;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initial?.nameEn ?? widget.initial?.name ?? '');
    _nameArCtrl = TextEditingController(text: widget.initial?.nameAr ?? '');
    _colorCtrl = TextEditingController(text: widget.initial?.colorCode ?? '#6366f1');
    _selectedParentId = (widget.initial?.parentId == 0) ? null : widget.initial?.parentId;
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'name': _nameCtrl.text.trim(),
        'name_en': _nameCtrl.text.trim(),
        'name_ar': _nameArCtrl.text.trim(),
        'color_code': _colorCtrl.text.trim(),
        'parent_id': _selectedParentId ?? 0,
        'is_active': _isActive,
      });
    }
  }

  Color _parseColor(String hex) {
    try {
      if (!hex.startsWith('#')) hex = '#$hex';
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtersState = ref.watch(filtersVmProvider);
    final filters = filtersState is AdminCrudData<FilterRow> ? filtersState.items : <FilterRow>[];
    final parentOptions = widget.initial != null
        ? filters.where((f) => f.id != widget.initial!.id).toList()
        : filters;

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
                  label: AdminLocalizations.translate(context, 'name (english)'),
                  hint: AdminLocalizations.translate(context, 'e.g. featured'),
                  borderRadius: 14,
                  validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'name is required') : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _nameArCtrl,
                  label: AdminLocalizations.translate(context, 'name (arabic)'),
                  hint: AdminLocalizations.translate(context, 'e.g. featured (arabic)'),
                  borderRadius: 14,
                  validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'arabic name is required') : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _colorCtrl,
                  label: AdminLocalizations.translate(context, 'color (hex)'),
                  hint: '#6366f1',
                  borderRadius: 14,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _parseColor(_colorCtrl.text),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                      ),
                    ),
                  ),
                  onChanged: (v) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppDropdown<int>(
                  label: AdminLocalizations.translate(context, 'parent tag'),
                  value: parentOptions.any((f) => f.id == _selectedParentId) ? _selectedParentId : null,
                  hint: AdminLocalizations.translate(context, 'none'),
                  onChanged: (value) => setState(() => _selectedParentId = value),
                  items: [
                    DropdownMenuItem<int>(
                      value: null,
                      child: Text(AdminLocalizations.translate(context, 'none')),
                    ),
                    ...parentOptions.map(
                      (f) => DropdownMenuItem<int>(
                        value: f.id,
                        child: Text(f.name),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(AdminLocalizations.translate(context, 'is active')),
            value: _isActive,
            onChanged: (val) => setState(() => _isActive = val),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'add tag') : AdminLocalizations.translate(context, 'save changes')),
          ),
        ],
      ),
    );
  }
}
