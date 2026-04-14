import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';

import '../view_model/warehouses_view_model.dart';
import '../widgets/warehouses_table.dart';
import '../widgets/warehouse_form.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';

class WarehousesView extends ConsumerWidget {
  const WarehousesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(warehousesVmProvider);
    final notifier = ref.read(warehousesVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: 'Inventory Warehouses',
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: 'Add Warehouse',
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
            title: state.isAdding ? 'Create Warehouse' : 'Edit Warehouse',
            size: AdminDialogSize.medium,
            child: WarehouseForm(
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

  Widget _buildBody(BuildContext context, AdminCrudState<WarehouseRow> state, bool isDark, WarehousesVm notifier) {
    return switch (state) {
      AdminCrudLoading() => const Center(child: CircularProgressIndicator()),
      AdminCrudError(:final message) => AdminStateWidget(message: message, onRetry: () => notifier.fetch()),
      AdminCrudData(:final items) => AppAnimation.fadeInUp(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
            ),
            child: WarehousesTable(
              items: items,
              onEdit: (w) => notifier.openEdit(w),
              onDelete: (id) => notifier.commitDelete(id),
              cardBuilder: (context, w) => _WarehouseCard(
                warehouse: w,
                onEdit: () => notifier.openEdit(w),
                onDelete: () => notifier.commitDelete(w.id),
              ),
            ),
          ),
        ),
    };
  }
}

class _WarehouseCard extends StatelessWidget {
  final WarehouseRow warehouse;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WarehouseCard({
    required this.warehouse,
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
                      warehouse.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    if (warehouse.location != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        warehouse.location!,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
                      ),
                    ],
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (warehouse.isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
                ),
                child: Text(
                  warehouse.isActive ? 'Active' : 'Inactive',
                  style: theme.textTheme.labelSmall?.copyWith(color: warehouse.isActive ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'ID: ${warehouse.id}',
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
