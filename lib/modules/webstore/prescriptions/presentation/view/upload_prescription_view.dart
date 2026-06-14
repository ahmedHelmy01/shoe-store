import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/modules/webstore/prescriptions/presentation/view_model/prescriptions_providers.dart';
import 'widgets/upload_circle_zone.dart';
import 'widgets/upload_notes_form.dart';
import 'widgets/image_source_bottom_sheet.dart';
import 'widgets/upload_success_dialog.dart';

class UploadPrescriptionView extends ConsumerStatefulWidget {
  const UploadPrescriptionView({super.key});

  @override
  ConsumerState<UploadPrescriptionView> createState() =>
      _UploadPrescriptionViewState();
}

class _UploadPrescriptionViewState extends ConsumerState<UploadPrescriptionView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _noteController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (image != null) {
        ref.read(uploadPrescriptionVmProvider.notifier).setPickedFile(image);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocaleKeys.webstore.prescriptions.pick_image_failed.tr(
              context: context,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final uploadState = ref.watch(uploadPrescriptionVmProvider);

    ref.listen<UploadPrescriptionState>(uploadPrescriptionVmProvider, (
      _,
      next,
    ) {
      if (next.success) {
        UploadSuccessDialog.show(context);
      } else if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return WebStoreBaseScaffold(
      showBack: true,
      title: Text(
        LocaleKeys.webstore.prescriptions.upload_title.tr(context: context),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
          color: isDark ? Colors.white : AppColors.textColor,
        ),
      ),
      body: Stack(
        children: [
          _buildBackgroundCircles(isDark),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  10.verticalSpace,
                  Text(
                    LocaleKeys.webstore.prescriptions.upload_subtitle.tr(
                      context: context,
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                  40.verticalSpace,
                  UploadCircleZone(
                    pulseAnimation: _pulseAnimation,
                    pickedFile: uploadState.pickedFile,
                    isUploading: uploadState.isUploading,
                    isDark: isDark,
                    onTap: () =>
                        ImageSourceBottomSheet.show(context, _pickImage),
                  ),
                  if (uploadState.pickedFile != null &&
                      !uploadState.isUploading) ...[
                    16.verticalSpace,
                    TextButton.icon(
                      onPressed: () =>
                          ImageSourceBottomSheet.show(context, _pickImage),
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: AppColors.primaryOrange,
                      ),
                      label: Text(
                        LocaleKeys.webstore.prescriptions.change_image.tr(
                          context: context,
                        ),
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                  40.verticalSpace,
                  UploadNotesForm(
                    controller: _noteController,
                    isUploading: uploadState.isUploading,
                    isDark: isDark,
                  ),
                  40.verticalSpace,
                  _buildUploadAction(uploadState, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCircles(bool isDark) {
    return Stack(
      children: [
        Positioned(
          top: -60.h,
          right: -60.w,
          child: Container(
            width: 220.w,
            height: 220.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryOrange.withValues(
                alpha: isDark ? 0.08 : 0.05,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 80.h,
          left: -80.w,
          child: Container(
            width: 260.w,
            height: 260.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue.withValues(
                alpha: isDark ? 0.06 : 0.04,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadAction(UploadPrescriptionState uploadState, bool isDark) {
    if (uploadState.isUploading) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: uploadState.uploadProgress,
              minHeight: 10.h,
              backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryOrange,
              ),
            ),
          ),
          12.verticalSpace,
          Text(
            '${LocaleKeys.webstore.prescriptions.uploading.tr(context: context)} ${(uploadState.uploadProgress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryOrange,
            ),
          ),
        ],
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: AppButton(
        onPressed: uploadState.pickedFile == null
            ? null
            : () => ref
                  .read(uploadPrescriptionVmProvider.notifier)
                  .upload(note: _noteController.text.trim()),
        child: Text(
          LocaleKeys.webstore.prescriptions.confirm_send.tr(context: context),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
