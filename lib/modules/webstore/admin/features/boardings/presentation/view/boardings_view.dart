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
import '../view_model/boardings_view_model.dart';
import '../widgets/boardings_table.dart';
import '../widgets/boarding_form.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/models/boarding_row.dart';

class BoardingsView extends ConsumerWidget {
  const BoardingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(boardingsVmProvider);
    final notifier = ref.read(boardingsVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'onboarding screens'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'new screen'),
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
            title: state.isAdding ? AdminLocalizations.translate(context, 'create boarding') : AdminLocalizations.translate(context, 'edit boarding'),
            size: AdminDialogSize.medium,
            child: BoardingForm(
              key: ValueKey(state.isAdding ? 'boarding-add' : 'boarding-edit-${state.editingItem?.id ?? 0}'),
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data, imageFile) async {
                final result = await notifier.commitSave(data, id: state.editingItem?.id, imageFile: imageFile);
                if (!context.mounted) return;

                if (result) {
                  notifier.closePanel();
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: state.isAdding ? AdminLocalizations.translate(context, 'boarding created') : AdminLocalizations.translate(context, 'boarding updated'),
                    message: AdminLocalizations.translate(context, 'the onboarding screen has been saved successfully.'),
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: AdminLocalizations.translate(context, 'save failed'),
                    message: AdminLocalizations.translate(context, 'could not save the onboarding screen. please try again.'),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<BoardingRow> state, bool isDark, BoardingsVm notifier) {
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
            child: BoardingsTable(
              items: items,
              onEdit: (b) => notifier.openEdit(b),
              onDelete: (id) => _confirmAndDelete(context, notifier, id, items.firstWhere((b) => b.id == id).title),
              cardBuilder: (context, b) => _BoardingCard(
                boarding: b,
                onView: () => showDialog(context: context, builder: (_) => BoardingDetailsDialog(boarding: b)),
                onEdit: () => notifier.openEdit(b),
                onDelete: () => _confirmAndDelete(context, notifier, b.id, b.title),
              ),
            ),
          ),
        ),
    };
  }

  void _confirmAndDelete(BuildContext context, BoardingsVm notifier, int id, String title) {
    AppDialog.show(
      context,
      title: AdminLocalizations.translate(context, 'delete onboarding screen'),
      message: '${AdminLocalizations.translate(context, 'are you sure you want to delete')} "$title"?',
      cancelText: AdminLocalizations.translate(context, 'cancel'),
      confirmText: AdminLocalizations.translate(context, 'delete'),
      onConfirm: () async {
        Navigator.pop(context);
        final success = await notifier.commitDelete(id);
        if (!context.mounted) return;
        if (success) {
          AppStatusDialog.show(context, status: AppDialogStatus.success, title: AdminLocalizations.translate(context, 'deleted'), message: AdminLocalizations.translate(context, 'onboarding screen deleted successfully.'));
        } else {
          AppStatusDialog.show(context, status: AppDialogStatus.error, title: AdminLocalizations.translate(context, 'delete failed'), message: AdminLocalizations.translate(context, 'could not delete onboarding screen.'));
        }
      },
    );
  }
}


class _BoardingCard extends StatelessWidget {
  final BoardingRow boarding;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BoardingCard({
    required this.boarding,
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
                      boarding.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      boarding.titleAr ?? AdminLocalizations.translate(context, 'no arabic title'),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
                    ),
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
              AdminStatusBadge(isActive: boarding.isActive),
              Text(
                '${AdminLocalizations.translate(context, 'id')}: ${boarding.id}',
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

