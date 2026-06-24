import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';

class PaymentMethodForm extends ConsumerStatefulWidget {
  final PaymentMethodRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data, XFile? imageFile) onSave;

  const PaymentMethodForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  ConsumerState<PaymentMethodForm> createState() => _PaymentMethodFormState();
}

class _PaymentMethodFormState extends ConsumerState<PaymentMethodForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _noteCtrl;
  late final TextEditingController _noteArCtrl;
  late final TextEditingController _sortOrderCtrl;
  late String _type;
  late bool _isActive;
  
  XFile? _imageFile;
  // Removed _uploadedImagePath as we now use direct file upload
  bool _removeInitialImage = false;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _nameCtrl = TextEditingController(text: i?.nameEn ?? i?.name ?? '');
    _nameArCtrl = TextEditingController(text: i?.nameAr ?? '');
    _noteCtrl = TextEditingController(text: i?.note ?? '');
    _noteArCtrl = TextEditingController(text: i?.noteAr ?? '');
    _sortOrderCtrl = TextEditingController(text: i?.sortOrder.toString() ?? '0');
    _type = i?.type ?? 'cod';
    _isActive = i?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _noteCtrl.dispose();
    _noteArCtrl.dispose();
    _sortOrderCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final data = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      'name_en': _nameCtrl.text.trim(),
      'name_ar': _nameArCtrl.text.trim(),
      'type': _type,
      'note': _noteCtrl.text.trim(),
      'note_en': _noteCtrl.text.trim(),
      'note_ar': _noteArCtrl.text.trim(),
      'sort_order': int.tryParse(_sortOrderCtrl.text.trim()) ?? 0,
      'is_active': _isActive,
    };

    if (_removeInitialImage && _imageFile == null) {
      data['image'] = '';
    } else if (_imageFile == null && widget.initial?.image != null) {
      // Keep existing image path if not changed or removed
      data['image'] = widget.initial!.image;
    }

    widget.onSave(data, _imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _nameCtrl,
                  label: 'Name (English)',
                  hint: 'e.g. Credit Card',
                  borderRadius: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _nameArCtrl,
                  label: 'Name (Arabic)',
                  hint: 'مثال: بطاقة ائتمان',
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
                  controller: _noteCtrl,
                  label: 'Note (English)',
                  hint: 'e.g. Additional fees apply',
                  borderRadius: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _noteArCtrl,
                  label: 'Note (Arabic)',
                  hint: 'مثال: تطبق رسوم إضافية',
                  borderRadius: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ref.watch(paymentMethodTypesProvider).when(
                  data: (types) => AppDropdown<String>(
                    label: 'Type',
                    hint: 'Select Type',
                    value: types.any((t) => t['value'] == _type) ? _type : null,
                    items: types.map((t) => DropdownMenuItem<String>(
                      value: t['value'] as String,
                      child: Text(t['label'] as String),
                    )).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _type = v);
                    },
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Error loading types: $e', style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _sortOrderCtrl,
                  label: 'Sort Order',
                  hint: '0',
                  keyboardType: TextInputType.number,
                  borderRadius: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AdminImagePicker(
            label: 'Method Icon',
            initialImage: widget.initial?.imageUrl,
            onImageSelected: (file) => setState(() => _imageFile = file),
            onRemoveInitial: () => setState(() => _removeInitialImage = true),
          ),
          const SizedBox(height: 20),
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
            child: Text(widget.initial == null ? 'Create Method' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
