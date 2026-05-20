import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/prescriptions/data/models/prescription_model.dart';
import 'package:erp/modules/webstore/prescriptions/presentation/view_model/prescriptions_providers.dart';
import 'widgets/prescription_image_viewer.dart';
import 'widgets/prescription_status_timeline.dart';
import 'widgets/prescription_notes_card.dart';
import 'widgets/prescription_edit_dialog.dart';
import 'widgets/prescription_delete_dialog.dart';

class PrescriptionDetailView extends ConsumerStatefulWidget {
  final PrescriptionModel prescription;

  const PrescriptionDetailView({super.key, required this.prescription});

  @override
  ConsumerState<PrescriptionDetailView> createState() => _PrescriptionDetailViewState();
}

class _PrescriptionDetailViewState extends ConsumerState<PrescriptionDetailView> {
  late PrescriptionModel _currentPrescription;

  @override
  void initState() {
    super.initState();
    _currentPrescription = widget.prescription;
  }

  void _onEdit() {
    PrescriptionEditDialog.show(
      context,
      currentNote: _currentPrescription.note,
      currentImagePath: _currentPrescription.image,
      onSave: (note, newImage) async {
        final success = await ref.read(prescriptionsVmProvider.notifier).editPrescription(
          _currentPrescription.id,
          newNote: note,
          currentImagePath: _currentPrescription.image,
          newImageFile: newImage,
        );

        if (success) {
          setState(() {
            _currentPrescription = PrescriptionModel(
              id: _currentPrescription.id,
              companyId: _currentPrescription.companyId,
              customerId: _currentPrescription.customerId,
              note: note,
              image: _currentPrescription.image, // Updated image path gets fetched on VM update
              status: _currentPrescription.status,
              reviewedBy: _currentPrescription.reviewedBy,
              createdAt: _currentPrescription.createdAt,
              updatedAt: DateTime.now(),
            );
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success
                  ? LocaleKeys.webstore.prescriptions.updated_success.tr(context: context)
                  : LocaleKeys.webstore.prescriptions.update_failed.tr(context: context)),
              backgroundColor: success ? AppColors.success : AppColors.error,
            ),
          );
        }
        return success;
      },
    );
  }

  void _onDelete() {
    PrescriptionDeleteDialog.show(context, onConfirm: () {
      ref.read(prescriptionsVmProvider.notifier).deletePrescription(_currentPrescription.id);
      AppNavigator.pop(context); // pop detail view
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.webstore.prescriptions.deleted_success.tr(context: context)),
          backgroundColor: AppColors.error,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WebStoreBaseScaffold(
      showBack: true,
      title: Text(
        LocaleKeys.webstore.prescriptions.detail_title.tr(context: context),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: isDark ? Colors.white : AppColors.textColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrescriptionImageViewer(
                prescriptionId: _currentPrescription.id,
                imagePath: _currentPrescription.image,
                isDark: isDark,
              ),
              24.verticalSpace,
              PrescriptionStatusTimeline(status: _currentPrescription.status, isDark: isDark),
              24.verticalSpace,
              PrescriptionNotesCard(
                prescription: _currentPrescription,
                isDark: isDark,
                onEdit: _onEdit,
              ),
              32.verticalSpace,
              AppAnimation.fadeInUp(
                duration: const Duration(milliseconds: 800),
                child: SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: OutlinedButton.icon(
                    onPressed: _onDelete,
                    icon: Icon(Icons.delete_outline_rounded, size: 20.sp),
                    label: Text(
                      LocaleKeys.webstore.prescriptions.delete_this.tr(context: context),
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
