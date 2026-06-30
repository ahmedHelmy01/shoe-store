import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import '../view_model/admin_prescriptions_view_model.dart';
import '../widgets/admin_prescriptions_table.dart';
import '../widgets/admin_prescription_review_form.dart';
import '../widgets/admin_prescription_details_dialog.dart';
import '../../data/models/admin_prescription_row.dart';

class AdminPrescriptionsView extends ConsumerWidget {
  const AdminPrescriptionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminPrescriptionsVmProvider);
    final notifier = ref.read(adminPrescriptionsVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'prescription requests'),
                onRefresh: () => notifier.fetch(),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildBody(context, state, notifier)),
            ],
          ),
        ),
        if (state.editingItem != null)
          AdminDialogForm(
            isOpen: true,
            onClose: () => notifier.closePanel(),
            title: '${AdminLocalizations.translate(context, 'review prescription')} #${state.editingItem!.id}',
            child: AdminPrescriptionReviewForm(
              prescription: state.editingItem!,
              isSaving: state.isSaving,
              onSave: (data) async {
                final result = await notifier.commitSave(data, id: state.editingItem!.id);
                if (result && context.mounted) {
                  notifier.closePanel();
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: AdminLocalizations.translate(context, 'review confirmed'),
                    message: AdminLocalizations.translate(context, 'prescription has been updated.'),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<AdminPrescriptionRow> state, AdminPrescriptionsVm notifier) {
    return switch (state) {
      AdminCrudLoading() => const Center(child: CircularProgressIndicator()),
      AdminCrudError(:final message) => AdminStateWidget(message: message, onRetry: () => notifier.fetch()),
      AdminCrudData(:final items) => AdminPrescriptionsTable(
          state: state,
          onView: (p) => showDialog(
            context: context,
            builder: (_) => AdminPrescriptionDetailsDialog(prescription: p),
          ),
          onReview: (p) => notifier.openEdit(p),
          onNextPage: () => notifier.nextPage(),
          onPrevPage: () => notifier.prevPage(),
          onServerPageSize: (size) => notifier.fetch(perPage: size, page: 1),
        ),
    };
  }
}
