import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/prescriptions/presentation/view_model/prescriptions_providers.dart';
import 'package:erp/modules/webstore/prescriptions/data/models/prescription_model.dart';
import 'widgets/prescription_card_widget.dart';
import 'widgets/prescription_shimmer_list.dart';
import 'widgets/prescription_edit_dialog.dart';
import 'widgets/prescription_delete_dialog.dart';

class PrescriptionsListView extends ConsumerStatefulWidget {
  const PrescriptionsListView({super.key});

  @override
  ConsumerState<PrescriptionsListView> createState() => _PrescriptionsListViewState();
}

class _PrescriptionsListViewState extends ConsumerState<PrescriptionsListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch fresh data every time the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(prescriptionsVmProvider.notifier).fetchFirstPage();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(prescriptionsVmProvider.notifier).fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(prescriptionsVmProvider);

    return WebStoreBaseScaffold(
      showBack: true,
      title: Text(
        LocaleKeys.webstore.prescriptions.title.tr(context: context),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: isDark ? Colors.white : AppColors.textColor),
      ),
      floatingActionButton: AppAnimation.fadeZoomIn(
        duration: const Duration(milliseconds: 600),
        child: FloatingActionButton.extended(
          onPressed: () {
            ref.read(uploadPrescriptionVmProvider.notifier).reset();
            AppNavigator.push(context, AppRouteNames.webstoreUploadPrescription);
          },
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 4,
          icon: const Icon(Icons.add_photo_alternate_rounded),
          label: Text(LocaleKeys.webstore.prescriptions.upload.tr(context: context),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(prescriptionsVmProvider.notifier).fetchFirstPage(),
          color: AppColors.primaryOrange,
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          child: state.prescriptions.when(
            data: (list) => list.isEmpty ? _buildEmptyView() : _buildListView(list, state.hasMore),
            loading: () => const PrescriptionShimmerList(),
            error: (err, _) => _buildErrorView(err.toString(), isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: AppEmptyWidget(
            message: LocaleKeys.webstore.prescriptions.empty_title,
            subtitle: LocaleKeys.webstore.prescriptions.empty_subtitle,
            icon: Icons.receipt_long_rounded,
            actionText: LocaleKeys.webstore.prescriptions.upload_new,
          ),
        ),
      ],
    );
  }

  Widget _buildListView(List<PrescriptionModel> list, bool hasMore) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: list.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == list.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
          );
        }
        final item = list[index];
        return AppAnimation.fadeInUp(
          key: ValueKey(item.id),
          duration: const Duration(milliseconds: 500),
          child: PrescriptionCardWidget(
            prescription: item,
            onTap: () => AppNavigator.push(context, AppRouteNames.webstorePrescriptionDetails, arguments: item),
            onEdit: () => _handleEdit(item),
            onDelete: () => _handleDelete(item),
          ),
        );
      },
    );
  }

  Widget _buildErrorView(String err, bool isDark) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 60.sp, color: AppColors.error),
                  16.verticalSpace,
                  Text(err, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp, color: isDark ? Colors.white70 : AppColors.textColor)),
                  24.verticalSpace,
                  ElevatedButton(
                    onPressed: () => ref.read(prescriptionsVmProvider.notifier).fetchFirstPage(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text(LocaleKeys.webstore.prescriptions.retry.tr(context: context)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleEdit(PrescriptionModel item) {
    PrescriptionEditDialog.show(
      context,
      currentNote: item.note,
      currentImagePath: item.image,
      onSave: (note, newImage) async {
        final success = await ref.read(prescriptionsVmProvider.notifier).editPrescription(
          item.id,
          newNote: note,
          currentImagePath: item.image,
          newImageFile: newImage,
        );
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

  void _handleDelete(PrescriptionModel item) {
    PrescriptionDeleteDialog.show(context, onConfirm: () {
      ref.read(prescriptionsVmProvider.notifier).deletePrescription(item.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(LocaleKeys.webstore.prescriptions.deleted_success.tr(context: context)),
        backgroundColor: AppColors.error,
      ));
    });
  }
}
