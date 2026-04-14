import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import '../view_model/filters_view_model.dart';
import '../widgets/filters_table.dart';
import '../widgets/filter_form.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';

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
                title: 'Filters',
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: 'Add Filter',
                onPrimaryAction: () => notifier.openAdd(),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildBody(context, state, isDark, notifier)),
            ],
          ),
        ),
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: state.isAdding || state.editingItem != null,
            onClose: () => notifier.closePanel(),
            title: state.isAdding ? 'Add Filter' : 'Edit Filter',
            size: AdminDialogSize.medium,
            child: FilterForm(
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                if (await notifier.commitSave(data, id: state.editingItem?.id)) {
                  notifier.closePanel();
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<FilterRow> state, bool isDark, FiltersVm notifier) {
    return switch (state) {
      AdminCrudLoading() => const Center(child: CircularProgressIndicator()),
      AdminCrudError(:final message) => AdminStateWidget(message: message, onRetry: () => notifier.fetch()),
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
              onDelete: (id) => notifier.commitDelete(id),
              cardBuilder: (context, f) => _FilterCard(
                filter: f,
                onEdit: () => notifier.openEdit(f),
                onDelete: () => notifier.commitDelete(f.id),
              ),
            ),
          ),
        ),
    };
  }
}

class _FilterCard extends StatelessWidget {
  final FilterRow filter;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FilterCard({
    required this.filter,
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
                      filter.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Type: ${filter.type}',
                      style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace', color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: onEdit,
                    child: const Row(children: [Icon(Icons.edit_outlined), SizedBox(width: 8), Text('Edit')]),
                  ),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: const Row(children: [Icon(Icons.delete_outline_rounded, color: Colors.red), SizedBox(width: 8), Text('Delete')]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (filter.isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
                ),
                child: Text(
                  filter.isActive ? 'Active' : 'Inactive',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: filter.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'ID: ${filter.id}',
                style: theme.textTheme.labelSmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
