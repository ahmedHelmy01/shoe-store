import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_card_popup_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../view_model/governorates_view_model.dart';
import '../widgets/governorates_table.dart';
import '../widgets/governorate_form.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';

class GovernoratesView extends ConsumerWidget {
  const GovernoratesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(governoratesVmProvider);
    final notifier = ref.read(governoratesVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'governorates'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'add gov'),
                onPrimaryAction: () => notifier.openAdd(),
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildBody(context, state, isDark, notifier)),
            ],
          ),
        ),
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: true,
            onClose: () => notifier.closePanel(),
            title: state.isAdding ? AdminLocalizations.translate(context, 'create governorate') : AdminLocalizations.translate(context, 'edit governorate'),
            size: AdminDialogSize.small,
            child: GovernorateForm(
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                final success = await notifier.commitSave(data, id: state.editingItem?.id);
                if (success && context.mounted) {
                  AppStatusDialog.showSuccess(
                    context,
                    message: state.isAdding 
                        ? AdminLocalizations.translate(context, 'governorate created successfully')
                        : AdminLocalizations.translate(context, 'governorate updated successfully'),
                  );
                  notifier.closePanel();
                } else if (!success && context.mounted) {
                  AppStatusDialog.showError(context, message: AdminLocalizations.translate(context, 'failed to save governorate'));
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<GovernorateRow> state, bool isDark, GovernoratesVm notifier) {
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
            child: GovernoratesTable(
              items: items,
              onEdit: (g) => notifier.openEdit(g),
              onDelete: (id) async {
                final success = await notifier.commitDelete(id);
                if (context.mounted) {
                  if (success) {
                    AppStatusDialog.showSuccess(context, message: 'Governorate deleted successfully');
                  } else {
                    AppStatusDialog.showError(context, message: 'Failed to delete governorate');
                  }
                }
              },
              cardBuilder: (context, g) => _GovernorateCard(
                gov: g,
                onView: () {
                  showDialog(
                    context: context,
                    builder: (_) => GovernorateDetailsDialog(gov: g),
                  );
                },
                onEdit: () => notifier.openEdit(g),
                onDelete: () {
                  AppDialog.show(
                    context,
                    title: AdminLocalizations.translate(context, 'delete governorate'),
                    message: AdminLocalizations.translate(context, 'are you sure you want to delete this governorate?'),
                    confirmText: AdminLocalizations.translate(context, 'delete'),
                    cancelText: AdminLocalizations.translate(context, 'cancel'),
                    onConfirm: () async {
                      Navigator.pop(context);
                      final success = await notifier.commitDelete(g.id);
                      if (context.mounted) {
                        if (success) {
                    AppStatusDialog.showSuccess(context, message: AdminLocalizations.translate(context, 'governorate deleted successfully'));
                        } else {
                    AppStatusDialog.showError(context, message: AdminLocalizations.translate(context, 'failed to delete governorate'));
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
    };
  }
}

class _GovernorateCard extends StatelessWidget {
  final GovernorateRow gov;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GovernorateCard({
    required this.gov,
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
                      gov.nameEn ?? gov.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      gov.nameAr ?? AdminLocalizations.translate(context, 'no arabic name'),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (gov.isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
                ),
                child: Text(
                   gov.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
                  style: theme.textTheme.labelSmall?.copyWith(color: gov.isActive ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${AdminLocalizations.translate(context, 'id')}: ${gov.id}',
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
