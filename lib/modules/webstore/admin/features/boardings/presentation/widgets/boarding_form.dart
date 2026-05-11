import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/models/boarding_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';

class BoardingForm extends StatefulWidget {
  final BoardingRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data, XFile? imageFile) onSave;

  const BoardingForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<BoardingForm> createState() => _BoardingFormState();
}

class _BoardingFormState extends State<BoardingForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _titleArCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _contentArCtrl;
  late final TextEditingController _positionCtrl;
  late bool _isActive;

  XFile? _imageFile;
  // Removed _uploadedImagePath as we now use direct file upload
  bool _removeInitialImage = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _titleArCtrl = TextEditingController(text: widget.initial?.titleAr ?? '');
    _contentCtrl = TextEditingController(text: widget.initial?.content ?? '');
    _contentArCtrl = TextEditingController(text: widget.initial?.contentAr ?? '');
    _positionCtrl = TextEditingController(text: widget.initial?.position.toString() ?? '1');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _titleArCtrl.dispose();
    _contentCtrl.dispose();
    _contentArCtrl.dispose();
    _positionCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{
        'title': _titleCtrl.text.trim(),
        'title_ar': _titleArCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'content_ar': _contentArCtrl.text.trim(),
        'position': int.tryParse(_positionCtrl.text.trim()) ?? 1,
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
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _titleCtrl,
                    label: 'Title (EN)',
                    hint: 'e.g. Welcome',
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _titleArCtrl,
                    label: 'Title (AR)',
                    hint: 'مرحبا',
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _contentCtrl,
                    label: 'Content (EN)',
                    hint: 'Welcome to our store',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _contentArCtrl,
                    label: 'Content (AR)',
                    hint: 'مرحبا بك في متجرنا',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AdminImagePicker(
              label: 'Onboarding Image',
              initialImage: widget.initial?.imageUrl,
              onImageSelected: (file) => setState(() => _imageFile = file),
              onRemoveInitial: () => setState(() => _removeInitialImage = true),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AppTextField(
                    controller: _positionCtrl,
                    label: 'Position',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: SwitchListTile(
                    title: const Text('Is Active'),
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: _submit,
              isLoading: widget.isSaving,
              child: Text(widget.initial == null ? 'Create Boarding' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
