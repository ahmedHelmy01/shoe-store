import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/models/slider_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class SliderForm extends StatefulWidget {
  final SliderRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data, XFile? imageFile) onSave;

  const SliderForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<SliderForm> createState() => _SliderFormState();
}

class _SliderFormState extends State<SliderForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _titleArCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _contentArCtrl;
  late bool _isActive;
  
  XFile? _imageFile;
  bool _removeInitialImage = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _titleArCtrl = TextEditingController(text: widget.initial?.titleAr ?? '');
    _contentCtrl = TextEditingController(text: widget.initial?.content ?? '');
    _contentArCtrl = TextEditingController(text: widget.initial?.contentAr ?? '');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _titleArCtrl.dispose();
    _contentCtrl.dispose();
    _contentArCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = <String, dynamic>{
        'title': _titleCtrl.text.trim(),
        'title_ar': _titleArCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'content_ar': _contentArCtrl.text.trim(),
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
                    label: AdminLocalizations.translate(context, 'title (en)'),
                    hint: AdminLocalizations.translate(context, 'e.g. summer sale'),
                    validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'required') : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _titleArCtrl,
                    label: AdminLocalizations.translate(context, 'title (ar)'),
                    hint: 'تخفيضات الصيف',
                    validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'required') : null,
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
                    label: AdminLocalizations.translate(context, 'content (en)'),
                    hint: 'Up to 50% off',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _contentArCtrl,
                    label: AdminLocalizations.translate(context, 'content (ar)'),
                    hint: 'خصم حتى 50%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AdminImagePicker(
              label: AdminLocalizations.translate(context, 'slider image'),
              initialImage: widget.initial?.imageUrl,
              onImageSelected: (file) => setState(() => _imageFile = file),
              onRemoveInitial: () => setState(() => _removeInitialImage = true),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(AdminLocalizations.translate(context, 'is active')),
              subtitle: Text(AdminLocalizations.translate(context, 'display this slider on the screen')),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: _submit,
              isLoading: widget.isSaving,
              child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'create slider') : AdminLocalizations.translate(context, 'save changes')),
            ),
          ],
        ),
      ),
    );
  }
}
