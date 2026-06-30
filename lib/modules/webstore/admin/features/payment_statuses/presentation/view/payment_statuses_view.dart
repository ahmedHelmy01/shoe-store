import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_card_popup_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/models/payment_status_row.dart';
import '../view_model/payment_statuses_view_model.dart';
import '../widgets/payment_statuses_table.dart';
import '../widgets/payment_status_form.dart';

class PaymentStatusesView extends ConsumerWidget {
  const PaymentStatusesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(paymentStatusesVmProvider);
    final notifier = ref.read(paymentStatusesVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'transaction statuses'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'add status'),
                onPrimaryAction: () => notifier.openAdd(),
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildBody(context, state, isDark, notifier)),
            ],
          ),
        ),
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: state.isAdding || state.editingItem != null,
            onClose: () => notifier.closePanel(),
            title: state.isAdding ? AdminLocalizations.translate(context, 'create payment status') : AdminLocalizations.translate(context, 'edit payment status'),
            size: AdminDialogSize.small,
            child: PaymentStatusForm(
              key: ValueKey(state.isAdding ? 'ps-add' : 'ps-edit-${state.editingItem?.id ?? 0}'),
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                final result = await notifier.commitSave(data, id: state.editingItem?.id);
                if (!context.mounted) return;

                if (result) {
                  notifier.closePanel();
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: state.isAdding ? AdminLocalizations.translate(context, 'payment status created') : AdminLocalizations.translate(context, 'payment status updated'),
                    message: AdminLocalizations.translate(context, 'the payment status has been saved successfully.'),
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: AdminLocalizations.translate(context, 'save failed'),
                    message: AdminLocalizations.translate(context, 'could not save the payment status. please try again.'),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<PaymentStatusRow> state, bool isDark, PaymentStatusesVm notifier) {
    return switch (state) {
      AdminCrudLoading() => const Center(child: CircularProgressIndicator()),
      AdminCrudError(:final message) => AdminStateWidget(message: message, onRetry: () => notifier.fetch()),
      AdminCrudData(:final items) => AppAnimation.fadeInUp(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isDark ? const Color(0xFF0F1B2D) : Colors.white,
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: PaymentStatusesTable(
              items: items,
              onEdit: (s) => notifier.openEdit(s),
              onDelete: (id) => _confirmAndDelete(context, notifier, id, items.firstWhere((s) => s.id == id).name),
              cardBuilder: (context, s) => _PaymentStatusCard(
                status: s,
                onView: () => showDialog(context: context, builder: (_) => PaymentStatusDetailsDialog(status: s)),
                onEdit: () => notifier.openEdit(s),
                onDelete: () => _confirmAndDelete(context, notifier, s.id, s.name),
              ),
            ),
          ),
        ),
    };
  }

  void _confirmAndDelete(BuildContext context, PaymentStatusesVm notifier, int id, String name) {
    AppDialog.show(
      context,
      title: AdminLocalizations.translate(context, 'delete payment status'),
      message: '${AdminLocalizations.translate(context, 'are you sure you want to delete')} "$name"?',
      cancelText: AdminLocalizations.translate(context, 'cancel'),
      confirmText: AdminLocalizations.translate(context, 'delete'),
      onConfirm: () async {
        Navigator.pop(context);
        final success = await notifier.commitDelete(id);
        if (!context.mounted) return;
        if (success) {
          AppStatusDialog.show(context, status: AppDialogStatus.success, title: AdminLocalizations.translate(context, 'deleted'), message: AdminLocalizations.translate(context, 'payment status deleted successfully.'));
        } else {
          AppStatusDialog.show(context, status: AppDialogStatus.error, title: AdminLocalizations.translate(context, 'delete failed'), message: AdminLocalizations.translate(context, 'could not delete payment status.'));
        }
      },
    );
  }
}

class _PaymentStatusCard extends StatelessWidget {
  final PaymentStatusRow status;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PaymentStatusCard({
    required this.status,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    if (status.nameAr != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        status.nameAr!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AdminCardPopupMenu(
                onView: onView,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdminStatusBadge(isActive: status.isActive),
              Text(
                '${AdminLocalizations.translate(context, 'id')}: ${status.id}',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
