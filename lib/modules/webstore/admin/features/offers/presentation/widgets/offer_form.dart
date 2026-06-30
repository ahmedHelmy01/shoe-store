import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';
import 'package:erp/modules/webstore/admin/features/offers/data/models/offer_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class OfferForm extends ConsumerStatefulWidget {
  final OfferRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data, XFile? imageFile) onSave;

  const OfferForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  ConsumerState<OfferForm> createState() => _OfferFormState();
}

class _OfferFormState extends ConsumerState<OfferForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _descArCtrl;
  late final TextEditingController _discountCtrl;
  late final TextEditingController _startDateCtrl;
  late final TextEditingController _endDateCtrl;
  late String _discountType;
  late bool _isActive;

  XFile? _imageFile;
  bool _removeInitialImage = false;

  final List<OfferProduct> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _nameCtrl = TextEditingController(text: i?.name ?? '');
    _nameArCtrl = TextEditingController(text: i?.nameAr ?? '');
    _descCtrl = TextEditingController(text: i?.description ?? '');
    _descArCtrl = TextEditingController(text: i?.descriptionAr ?? '');
    _discountCtrl = TextEditingController(text: i?.discountValue.toString() ?? '');
    _startDateCtrl = TextEditingController(text: i?.startDate ?? '');
    _endDateCtrl = TextEditingController(text: i?.endDate ?? '');
    _discountType = i?.discountType ?? 'percentage';
    _isActive = i?.isActive ?? true;
    if (i != null) {
      _selectedProducts.addAll(i.products);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _descCtrl.dispose();
    _descArCtrl.dispose();
    _discountCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final theme = Theme.of(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: ColorScheme.light(
              primary: theme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: theme.primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      ctrl.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _pickProducts() async {
    final allProducts = await ref.read(allProductsProvider.future);
    if (!mounted) return;
    final selectedIds = _selectedProducts.map((p) => p.productId).toSet();
    final result = await showDialog<List<int>>(
      context: context,
      builder: (ctx) => _ProductPickerDialog(
        allProducts: allProducts,
        selectedIds: selectedIds,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _selectedProducts.clear();
      for (final id in result) {
        _selectedProducts.add(OfferProduct(productId: id));
      }
    });
  }

  void _removeProduct(int productId) {
    setState(() {
      _selectedProducts.removeWhere((p) => p.productId == productId);
    });
  }

  void _submit() {
    final data = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      'name_ar': _nameArCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'description_ar': _descArCtrl.text.trim(),
      'discount_type': _discountType == 'percentage' ? 1 : 2,
      'discount_value': double.tryParse(_discountCtrl.text.trim()) ?? 0,
      'start_date': _startDateCtrl.text.trim(),
      'end_date': _endDateCtrl.text.trim(),
      'is_active': _isActive,
      'products': _selectedProducts.map((p) => p.toJson()).toList(),
    };

    if (_removeInitialImage && _imageFile == null) {
      data['image'] = '';
    } else if (_imageFile == null && widget.initial?.image != null) {
      data['image'] = widget.initial!.image;
    }

    widget.onSave(data, _imageFile);
  }

  @override
  Widget build(BuildContext context) {
    final allProductsAsync = ref.watch(allProductsProvider);
    final loc = AdminLocalizations.translate;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _nameCtrl,
                  label: loc(context, 'Name (EN)'),
                  hint: loc(context, 'Offer name in English'),
                  borderRadius: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _nameArCtrl,
                  label: loc(context, 'Name (AR)'),
                  hint: 'اسم العرض',
                  borderRadius: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _descCtrl,
                  label: loc(context, 'Description (EN)'),
                  hint: loc(context, 'Offer description in English'),
                  borderRadius: 14,
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _descArCtrl,
                  label: loc(context, 'Description (AR)'),
                  hint: 'وصف العرض',
                  borderRadius: 14,
                  maxLines: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _discountCtrl,
                  label: loc(context, 'Discount Value'),
                  hint: '0.0',
                  keyboardType: TextInputType.number,
                  borderRadius: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppDropdown<String>(
                  value: _discountType,
                  label: loc(context, 'Discount Type'),
                  items: [
                    DropdownMenuItem(value: 'percentage', child: Text(loc(context, 'Percentage %'))),
                    DropdownMenuItem(value: 'fixed', child: Text(loc(context, 'Fixed Amount'))),
                  ],
                  onChanged: (v) => setState(() => _discountType = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDate(_startDateCtrl),
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _startDateCtrl,
                      label: loc(context, 'Start Date'),
                      hint: '2026-01-01',
                      borderRadius: 14,
                      suffixIcon: const Icon(Icons.calendar_month_rounded, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDate(_endDateCtrl),
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _endDateCtrl,
                      label: loc(context, 'End Date'),
                      hint: '2026-12-31',
                      borderRadius: 14,
                      suffixIcon: const Icon(Icons.calendar_month_rounded, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AdminImagePicker(
            label: loc(context, 'Offer Image'),
            initialImage: widget.initial?.imageUrl,
            onImageSelected: (file) => setState(() => _imageFile = file),
            onRemoveInitial: () => setState(() => _removeInitialImage = true),
          ),
          const SizedBox(height: 24),
          _buildProductSelector(allProductsAsync),
          const SizedBox(height: 20),
          SwitchListTile(
            title: Text(loc(context, 'Is Active')),
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? loc(context, 'Create Offer') : loc(context, 'Save Changes')),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSelector(AsyncValue<List<ProductRow>> allProductsAsync) {
    final theme = Theme.of(context);
    final loc = AdminLocalizations.translate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(loc(context, 'Products'), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const Spacer(),
            TextButton.icon(
              onPressed: _selectedProducts.isEmpty ? null : _pickProducts,
              icon: const Icon(Icons.edit, size: 18),
              label: Text(loc(context, 'Change')),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_selectedProducts.isEmpty)
          OutlinedButton.icon(
            onPressed: _pickProducts,
            icon: const Icon(Icons.add),
            label: Text(loc(context, 'Select Products')),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          )
        else
          allProductsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('${AdminLocalizations.translate(context, 'Failed to load products')}: $e'),
            data: (allProducts) {
              final productMap = {for (final p in allProducts) p.id: p};
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedProducts.map((op) {
                  final product = productMap[op.productId];
                  final name = product?.name ?? 'Product #${op.productId}';
                  final imageUrl = product?.imageUrl;
                  return Chip(
                    avatar: imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(imageUrl, width: 28, height: 28, fit: BoxFit.cover, errorBuilder: (_, _, _) => const Icon(Icons.inventory_2, size: 20)),
                          )
                        : const Icon(Icons.inventory_2, size: 20),
                    label: Text(name, style: const TextStyle(fontSize: 13)),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeProduct(op.productId),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }
}

class _ProductPickerDialog extends StatefulWidget {
  final List<ProductRow> allProducts;
  final Set<int> selectedIds;

  const _ProductPickerDialog({
    required this.allProducts,
    required this.selectedIds,
  });

  @override
  State<_ProductPickerDialog> createState() => _ProductPickerDialogState();
}

class _ProductPickerDialogState extends State<_ProductPickerDialog> {
  late final Set<int> _selected;
  final _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedIds);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ProductRow> get _filtered {
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return widget.allProducts;
    return widget.allProducts.where((p) =>
      p.name.toLowerCase().contains(q) ||
      p.id.toString().contains(q) ||
      p.sku.toLowerCase().contains(q)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AdminLocalizations.translate;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(loc(context, 'Select Products'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: loc(context, 'Search products...'),
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: ListView(
                children: _filtered.map((p) {
                  final selected = _selected.contains(p.id);
                  return CheckboxListTile(
                    value: selected,
                    secondary: p.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(p.imageUrl!, width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_, _, _) => const Icon(Icons.inventory_2)),
                          )
                        : const Icon(Icons.inventory_2),
                    title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('ID: ${p.id} | ${p.sku}', style: theme.textTheme.bodySmall),
                    onChanged: (v) {
                      setState(() {
                        if (v == true) {
                          _selected.add(p.id);
                        } else {
                          _selected.remove(p.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(loc(context, 'Cancel')),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                    onPressed: () => Navigator.pop(context, _selected.toList()),
                    child: Text('${AdminLocalizations.translate(context, 'Add')} (${_selected.length})'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
