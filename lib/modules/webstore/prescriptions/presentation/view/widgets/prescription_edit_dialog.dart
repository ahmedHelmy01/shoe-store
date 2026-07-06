import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/network/network_url.dart';

class PrescriptionEditDialog extends StatefulWidget {
  final String currentNote;
  final String currentImagePath;
  final Future<bool> Function(String note, XFile? newImage) onSave;

  const PrescriptionEditDialog({
    super.key,
    required this.currentNote,
    required this.currentImagePath,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required String currentNote,
    required String currentImagePath,
    required Future<bool> Function(String note, XFile? newImage) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (_) => PrescriptionEditDialog(
        currentNote: currentNote,
        currentImagePath: currentImagePath,
        onSave: onSave,
      ),
    );
  }

  @override
  State<PrescriptionEditDialog> createState() => _PrescriptionEditDialogState();
}

class _PrescriptionEditDialogState extends State<PrescriptionEditDialog> {
  late final TextEditingController _controller;
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(LocaleKeys.webstore.prescriptions.select_image_source.tr(context: ctx)),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
            child: Row(children: [
              Icon(Icons.camera_alt_rounded, color: AppColors.primaryOrange, size: 22.sp),
              12.horizontalSpace,
              Text(LocaleKeys.webstore.prescriptions.camera.tr(context: ctx)),
            ]),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
            child: Row(children: [
              Icon(Icons.photo_library_rounded, color: AppColors.primaryBlue, size: 22.sp),
              12.horizontalSpace,
              Text(LocaleKeys.webstore.prescriptions.gallery.tr(context: ctx)),
            ]),
          ),
        ],
      ),
    );
    if (source == null) return;
    final file = await _picker.pickImage(source: source, imageQuality: 85, maxWidth: 1200);
    if (file != null) setState(() => _pickedFile = file);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E2640) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        LocaleKeys.webstore.prescriptions.edit_notes.tr(context: context),
        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textColor),
      ),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Image preview + change button
          GestureDetector(
            onTap: _picking,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width: 100.w, height: 100.w,
                child: _pickedFile != null
                    ? AppImage(imagePath: 'file://${_pickedFile!.path}', fit: BoxFit.cover)
                    : AppImage(imagePath: NetworkUrl.fullUrl(widget.currentImagePath), fit: BoxFit.cover),
              ),
            ),
          ),
          8.verticalSpace,
          TextButton.icon(
            onPressed: _picking,
            icon: Icon(Icons.camera_alt_rounded, size: 16.sp, color: AppColors.primaryOrange),
            label: Text(
              LocaleKeys.webstore.prescriptions.change_image.tr(context: context),
              style: TextStyle(color: AppColors.primaryOrange, fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
          12.verticalSpace,
          TextField(
            controller: _controller,
            maxLines: 3,
            style: TextStyle(color: isDark ? Colors.white : AppColors.textColor),
            decoration: InputDecoration(
              hintText: LocaleKeys.webstore.prescriptions.edit_notes_hint.tr(context: context),
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
            ),
          ),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: Text(LocaleKeys.common.cancel.tr(context: context), style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
          child: _saving
              ? SizedBox(width: 18.w, height: 18.w, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(LocaleKeys.common.save.tr(context: context), style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _picking() => _pickImage();

  Future<void> _onSave() async {
    setState(() => _saving = true);
    final success = await widget.onSave(_controller.text.trim(), _pickedFile);
    if (mounted) {
      Navigator.pop(context, success);
    }
  }
}
