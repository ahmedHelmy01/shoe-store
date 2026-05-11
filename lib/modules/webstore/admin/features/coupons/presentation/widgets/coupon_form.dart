import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';

class CouponForm extends StatefulWidget {
  final CouponRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data, XFile? imageFile) onSave;

  const CouponForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<CouponForm> createState() => _CouponFormState();
}

class _CouponFormState extends State<CouponForm> {
  late final TextEditingController _codeCtrl;
  late final TextEditingController _discountCtrl;
  late final TextEditingController _minOrderCtrl;
  late final TextEditingController _maxUsesCtrl;
  late final TextEditingController _maxUsesPerCustomerCtrl;
  late final TextEditingController _startsAtCtrl;
  late final TextEditingController _expiresAtCtrl;
  late String _discountType;
  late bool _isActive;
  
  XFile? _imageFile;
  // Removed _uploadedImagePath as we now use direct file upload
  bool _removeInitialImage = false;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _codeCtrl = TextEditingController(text: i?.code ?? '');
    _discountCtrl = TextEditingController(text: i?.discountValue.toString() ?? '');
    _minOrderCtrl = TextEditingController(text: i?.minimumOrderValue.toString() ?? '0');
    _maxUsesCtrl = TextEditingController(text: i?.maxUses.toString() ?? '100');
    _maxUsesPerCustomerCtrl = TextEditingController(text: i?.maxUsesPerCustomer.toString() ?? '1');
    _startsAtCtrl = TextEditingController(text: i?.startsAt ?? '');
    _expiresAtCtrl = TextEditingController(text: i?.expiresAt ?? '');
    _discountType = i?.discountType ?? 'percentage';
    _isActive = i?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _discountCtrl.dispose();
    _minOrderCtrl.dispose();
    _maxUsesCtrl.dispose();
    _maxUsesPerCustomerCtrl.dispose();
    _startsAtCtrl.dispose();
    _expiresAtCtrl.dispose();
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

  void _submit() {
    final data = <String, dynamic>{
      'code': _codeCtrl.text.trim().toUpperCase(),
      'discount_type': _discountType == 'percentage' ? 1 : 2,
      'discount_value': double.tryParse(_discountCtrl.text.trim()) ?? 0,
      'minimum_order_value': double.tryParse(_minOrderCtrl.text.trim()) ?? 0,
      'usage_limit': int.tryParse(_maxUsesCtrl.text.trim()) ?? 100,
      'per_user_limit': int.tryParse(_maxUsesPerCustomerCtrl.text.trim()) ?? 1,
      'start_date': _startsAtCtrl.text.trim(),
      'end_date': _expiresAtCtrl.text.trim(),
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
          AppTextField(
            controller: _codeCtrl,
            label: 'Coupon Code',
            hint: 'e.g. SAVE20',
            borderRadius: 14,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _discountCtrl,
                  label: 'Discount Value',
                  hint: '0.0',
                  keyboardType: TextInputType.number,
                  borderRadius: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppDropdown<String>(
                  value: _discountType,
                  label: 'Discount Type',
                  items: const [
                    DropdownMenuItem(value: 'percentage', child: Text('Percentage %')),
                    DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount')),
                  ],
                  onChanged: (v) => setState(() => _discountType = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _minOrderCtrl,
            label: 'Minimum Order Value',
            hint: '0',
            keyboardType: TextInputType.number,
            borderRadius: 14,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _maxUsesCtrl,
                  label: 'Max Uses',
                  hint: '100',
                  keyboardType: TextInputType.number,
                  borderRadius: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _maxUsesPerCustomerCtrl,
                  label: 'Max Uses Per Customer',
                  hint: '1',
                  keyboardType: TextInputType.number,
                  borderRadius: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDate(_startsAtCtrl),
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _startsAtCtrl,
                      label: 'Starts At',
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
                  onTap: () => _pickDate(_expiresAtCtrl),
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _expiresAtCtrl,
                      label: 'Expires At',
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
            label: 'Coupon Image',
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
            child: Text(widget.initial == null ? 'Create Coupon' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
