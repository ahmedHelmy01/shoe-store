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
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../view_model/pages_view_model.dart';
import '../widgets/pages_table.dart';
import '../widgets/page_form.dart';

class PagesView extends ConsumerWidget {
  const PagesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(pagesVmProvider);
    final notifier = ref.read(pagesVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'content pages'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'add page'),
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
            title: state.isAdding ? AdminLocalizations.translate(context, 'create page') : AdminLocalizations.translate(context, 'edit page'),
            size: AdminDialogSize.large,
            child: PageForm(
              key: ValueKey(state.isAdding ? 'page-add' : 'page-edit-${state.editingItem?.id ?? 0}'),
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
                    title: state.isAdding ? AdminLocalizations.translate(context, 'page created') : AdminLocalizations.translate(context, 'page updated'),
                    message: AdminLocalizations.translate(context, 'the page has been saved successfully.'),
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: AdminLocalizations.translate(context, 'save failed'),
                    message: AdminLocalizations.translate(context, 'could not save the page. please try again.'),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<PageRow> state, bool isDark, PagesVm notifier) {
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
            child: PagesTable(
              items: items,
              onEdit: (p) => notifier.openEdit(p),
              onDelete: (id) => _confirmAndDelete(context, notifier, id, items.firstWhere((p) => p.id == id).title),
              cardBuilder: (context, p) => _PageCard(
                page: p,
                onView: () => showDialog(context: context, builder: (_) => PageDetailsDialog(page: p)),
                onEdit: () => notifier.openEdit(p),
                onDelete: () => _confirmAndDelete(context, notifier, p.id, p.title),
              ),
            ),
          ),
        ),
    };
  }

  void _confirmAndDelete(BuildContext context, PagesVm notifier, int id, String title) {
    AppDialog.show(
      context,
      title: AdminLocalizations.translate(context, 'delete page'),
      message: '${AdminLocalizations.translate(context, 'are you sure you want to delete')} "$title"?',
      cancelText: AdminLocalizations.translate(context, 'cancel'),
      confirmText: AdminLocalizations.translate(context, 'delete'),
      onConfirm: () async {
        Navigator.pop(context);
        final success = await notifier.commitDelete(id);
        if (!context.mounted) return;
        if (success) {
          AppStatusDialog.show(context, status: AppDialogStatus.success, title: AdminLocalizations.translate(context, 'deleted'), message: AdminLocalizations.translate(context, 'page deleted successfully.'));
        } else {
          AppStatusDialog.show(context, status: AppDialogStatus.error, title: AdminLocalizations.translate(context, 'delete failed'), message: AdminLocalizations.translate(context, 'could not delete page.'));
        }
      },
    );
  }
}

class _PageCard extends StatelessWidget {
  final PageRow page;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PageCard({
    required this.page,
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
                      page.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '/${page.slug}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
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
              AdminStatusBadge(isActive: page.isActive),
              Text(
                '${AdminLocalizations.translate(context, 'id')}: ${page.id}',
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
