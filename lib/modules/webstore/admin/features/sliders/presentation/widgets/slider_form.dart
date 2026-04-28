import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/models/slider_row.dart';

class SliderForm extends StatefulWidget {
  final SliderRow? initial;
  final bool isSaving;
  final void Function(Map<String, dynamic> data) onSave;

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
  late final TextEditingController _imageCtrl;
  late final TextEditingController _titleUrlCtrl;
  late final TextEditingController _openTargetCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _positionCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initial?.title ?? '');
    _titleArCtrl = TextEditingController(text: widget.initial?.titleAr ?? '');
    _contentCtrl = TextEditingController(text: widget.initial?.content ?? '');
    _contentArCtrl = TextEditingController(text: widget.initial?.contentAr ?? '');
    _imageCtrl = TextEditingController(text: widget.initial?.image ?? '');
    _titleUrlCtrl = TextEditingController(text: widget.initial?.titleUrl ?? '');
    _openTargetCtrl = TextEditingController(text: widget.initial?.openTarget ?? '_self');
    _locationCtrl = TextEditingController(text: widget.initial?.location ?? 'home');
    _positionCtrl = TextEditingController(text: widget.initial?.position.toString() ?? '1');
    _isActive = widget.initial?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _titleArCtrl.dispose();
    _contentCtrl.dispose();
    _contentArCtrl.dispose();
    _imageCtrl.dispose();
    _titleUrlCtrl.dispose();
    _openTargetCtrl.dispose();
    _locationCtrl.dispose();
    _positionCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'title': _titleCtrl.text.trim(),
        'title_ar': _titleArCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'content_ar': _contentArCtrl.text.trim(),
        'image': _imageCtrl.text.trim(),
        'title_url': _titleUrlCtrl.text.trim(),
        'open_target': _openTargetCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'position': int.tryParse(_positionCtrl.text.trim()) ?? 1,
        'is_active': _isActive,
      });
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
                    hint: 'e.g. Summer Sale',
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _titleArCtrl,
                    label: 'Title (AR)',
                    hint: 'تخفيضات الصيف',
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
                    hint: 'Up to 50% off',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _contentArCtrl,
                    label: 'Content (AR)',
                    hint: 'خصم حتى 50%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AppTextField(
              controller: _imageCtrl,
              label: 'Image Path/URL',
              hint: 'uploads/sliders/summer.jpg',
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _titleUrlCtrl,
                    label: 'URL Link',
                    hint: '/sale',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _openTargetCtrl,
                    label: 'Open Target',
                    hint: '_self or _blank',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _locationCtrl,
                    label: 'Location',
                    hint: 'home',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    controller: _positionCtrl,
                    label: 'Position',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SwitchListTile(
              title: const Text('Is Active'),
              subtitle: const Text('Display this slider on the screen'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            AppButton(
              onPressed: _submit,
              isLoading: widget.isSaving,
              child: Text(widget.initial == null ? 'Create Slider' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

