import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import '../view_model/filters_view_model.dart';
import '../widgets/filters_table.dart';
import '../widgets/filter_form.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';

class FiltersView extends ConsumerWidget {
  const FiltersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(filtersVmProvider);
    final notifier = ref.read(filtersVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'tags'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'add tag'),
                onPrimaryAction: () => notifier.openAdd(),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildBody(context, ref, state, isDark, notifier)),
            ],
          ),
        ),
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: state.isAdding || state.editingItem != null,
            onClose: () => notifier.closePanel(),
            title: state.isAdding ? AdminLocalizations.translate(context, 'add tag') : AdminLocalizations.translate(context, 'edit tag'),
            size: AdminDialogSize.medium,
            child: FilterForm(
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                final isSuccess = await notifier.commitSave(data, id: state.editingItem?.id);
                if (!context.mounted) return;

                if (isSuccess) {
                  notifier.closePanel();
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: state.editingItem == null ? AdminLocalizations.translate(context, 'tag added') : AdminLocalizations.translate(context, 'tag updated'),
                    message: AdminLocalizations.translate(context, 'the tag has been saved successfully.'),
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: AdminLocalizations.translate(context, 'save failed'),
                    message: AdminLocalizations.translate(context, 'failed to save tag. please try again.'),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AdminCrudState<FilterRow> state,
    bool isDark,
    FiltersVm notifier,
  ) {
    return switch (state) {
      AdminCrudLoading() => const Center(child: CircularProgressIndicator()),
      AdminCrudError(:final message) => AdminStateWidget(
        message: message,
        onRetry: () => notifier.fetch(),
      ),
      AdminCrudData(:final items) => AppAnimation.fadeInUp(
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F1B2D) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.05,
              ),
            ),
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
          child: FiltersTable(
            items: items,
            onEdit: (f) => notifier.openEdit(f),
            onDelete: (id) => _confirmAndDelete(context, notifier, id, items.firstWhere((f) => f.id == id).name),
            cardBuilder: (context, f) => _FilterCard(
              filter: f,
              onView: () => _showDetails(context, ref, f),
              onEdit: () => notifier.openEdit(f),
              onDelete: () => _confirmAndDelete(context, notifier, f.id, f.name),
            ),
          ),
        ),
      ),
    };
  }

  void _showDetails(BuildContext context, WidgetRef ref, FilterRow f) {
    final parentTagName = () {
      final parentId = f.parentId;
      if (parentId == null || parentId == 0) return AdminLocalizations.translate(context, 'none');
      final state = ref.read(filtersVmProvider);
      if (state is AdminCrudData<FilterRow>) {
        for (final item in state.items) {
          if (item.id == parentId) return item.name;
        }
      }
      return 'ID: $parentId';
    }();

    showDialog(
      context: context,
      builder: (context) => AdminDetailsDialog(
        title: AdminLocalizations.translate(context, 'tag details'),
        id: f.id.toString(),
        icon: Icons.local_offer_rounded,
        children: [
          Row(
            children: [
              Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (english)'), f.nameEn ?? f.name, Icons.language_rounded, bottomPadding: 0)),
              const SizedBox(width: 16),
              Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (arabic)'), f.nameAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'parent tag'), parentTagName, Icons.account_tree_rounded, bottomPadding: 0)),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AdminDetailsDialog.buildDetailRow(
                        context,
                        AdminLocalizations.translate(context, 'color'),
                        f.colorCode ?? '#6366f1',
                        Icons.palette_rounded,
                        bottomPadding: 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: () {
                            try {
                              var hex = f.colorCode ?? '#6366f1';
                              if (!hex.startsWith('#')) hex = '#$hex';
                              return Color(int.parse(hex.replaceFirst('#', '0xFF')));
                            } catch (_) {
                              return Colors.grey;
                            }
                          }(),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AdminDetailsDialog.buildStatusRow(context, f.isActive),
        ],
      ),
    );
  }

  void _confirmAndDelete(BuildContext context, FiltersVm notifier, int id, String name) {
    AppDialog.show(
      context,
      title: AdminLocalizations.translate(context, 'delete tag'),
      message: '${AdminLocalizations.translate(context, 'are you sure you want to delete')} "$name"?',
      cancelText: AdminLocalizations.translate(context, 'cancel'),
      confirmText: AdminLocalizations.translate(context, 'delete'),
      onConfirm: () async {
        Navigator.pop(context);
        final success = await notifier.commitDelete(id);
        if (!context.mounted) return;
        if (success) {
          AppStatusDialog.show(
            context,
            status: AppDialogStatus.success,
            title: AdminLocalizations.translate(context, 'deleted'),
            message: AdminLocalizations.translate(context, 'tag deleted successfully.'),
          );
        } else {
          AppStatusDialog.show(
            context,
            status: AppDialogStatus.error,
            title: AdminLocalizations.translate(context, 'delete failed'),
            message: AdminLocalizations.translate(context, 'could not delete tag. please try again.'),
          );
        }
      },
    );
  }
}

class _FilterCard extends StatelessWidget {
  final FilterRow filter;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FilterCard({
    required this.filter,
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
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
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
                      filter.nameEn ?? filter.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      filter.nameAr ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: onView,
                    child: Row(children: [const Icon(Icons.visibility_outlined), const SizedBox(width: 8), Text(AdminLocalizations.translate(context, 'details'))]),
                  ),
                  PopupMenuItem(
                    onTap: onEdit,
                    child: Row(children: [const Icon(Icons.edit_outlined), const SizedBox(width: 8), Text(AdminLocalizations.translate(context, 'edit'))]),
                  ),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: Row(children: [const Icon(Icons.delete_outline_rounded, color: Colors.red), const SizedBox(width: 8), Text(AdminLocalizations.translate(context, 'delete'))]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdminStatusBadge(isActive: filter.isActive),
              Text(
                'ID: ${filter.id}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
