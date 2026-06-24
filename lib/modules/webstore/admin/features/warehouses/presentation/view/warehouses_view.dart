import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_card_popup_menu.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';
import 'package:erp/modules/webstore/admin/features/branches/presentation/view_model/branches_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_action_icon_button.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_panel.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';

import '../view_model/warehouses_view_model.dart';
import '../widgets/warehouses_table.dart';
import '../widgets/warehouse_form.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/data/models/warehouse_row.dart';

class WarehousesView extends ConsumerStatefulWidget {
  const WarehousesView({super.key});

  @override
  ConsumerState<WarehousesView> createState() => _WarehousesViewState();
}

class _WarehousesViewState extends ConsumerState<WarehousesView> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(branchesVmProvider.notifier).fetch(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(warehousesVmProvider);
    final branchesState = ref.watch(branchesVmProvider);
    final notifier = ref.read(warehousesVmProvider.notifier);
    final branches = branchesState is AdminCrudData<BranchRow>
        ? branchesState.items
        : const <BranchRow>[];
    print(
      '[WAREHOUSE_UI] build -> isAdding=${state.isAdding}, editingItem=${state.editingItem?.id}, isSaving=${state.isSaving}',
    );

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
                onPrimaryAction: () {
                  print('[WAREHOUSE_UI] Add button clicked');
                  notifier.openAdd();
                },
              ),

              const SizedBox(height: 12),
              Expanded(child: _buildBody(context, state, isDark, notifier, branches)),
            ],
          ),
        ),
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: state.isAdding || state.editingItem != null,
            onClose: () => notifier.closePanel(),
            title: state.isAdding ? 'Create Warehouse' : 'Edit Warehouse',
            size: AdminDialogSize.medium,
            closeOnBackdropTap: false,
            child: WarehouseForm(
              key: ValueKey(state.isAdding ? 'warehouse-add' : 'warehouse-edit-${state.editingItem?.id ?? 0}'),
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                final success = await notifier.commitSave(data, id: state.editingItem?.id);
                if (!context.mounted) return;
                
                if (success) {
                  notifier.closePanel();
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: state.isAdding ? 'Warehouse Created' : 'Warehouse Updated',
                    message: 'The warehouse has been saved successfully.',
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: 'Save Failed',
                    message: 'Could not save the warehouse. Please try again.',
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<WarehouseRow> state, bool isDark, WarehousesVm notifier, List<BranchRow> branches) {
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
            child: WarehousesTable(
              items: items,
              onEdit: (w) => notifier.openEdit(w),
              onView: (w) => _showDetails(context, w, branches),
              onDelete: (w) => _confirmAndDelete(context, notifier, w),
              cardBuilder: (context, w) => _WarehouseCard(
                warehouse: w,
                onView: () => _showDetails(context, w, branches),
                onEdit: () => notifier.openEdit(w),
                onDelete: () => _confirmAndDelete(context, notifier, w),
              ),
            ),
          ),
        ),
    };
  }

  Future<void> _confirmAndDelete(
    BuildContext context,
    WarehousesVm notifier,
    WarehouseRow warehouse,
  ) async {
    print('[WAREHOUSE_UI] delete requested -> id=${warehouse.id}');
    AppDialog.show(
      context,
      title: 'Delete Warehouse',
      message: 'Are you sure you want to delete "${warehouse.name}"?',
      cancelText: 'Cancel',
      confirmText: 'Delete',
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () async {
        Navigator.of(context).pop();
        print('[WAREHOUSE_UI] delete confirm -> id=${warehouse.id}');
        final result = await notifier.deleteWarehouse(warehouse.id);
        if (!mounted) return;
        result.when(
          success: (_) async {
            await AppStatusDialog.show(
              context,
              status: AppDialogStatus.success,
              title: 'Deleted',
              message: 'Warehouse deleted successfully.',
            );
          },
          failure: (e) async {
            await AppStatusDialog.show(
              context,
              status: AppDialogStatus.error,
              title: 'Delete Failed',
              message: e.message,
            );
          },
        );
      },
    );
  }

  void _showDetails(BuildContext context, WarehouseRow w, List<BranchRow> branches) {
    final branchName = () {
      final branchId = w.branchId;
      if (branchId == null) return '-';
      for (final branch in branches) {
        if (branch.id == branchId) return branch.name;
      }
      return '-';
    }();

    final parentWarehouseName = () {
      final parentId = w.parentWarehouseId;
      if (parentId == null || parentId == 0) return 'None (لا يوجد)';
      
      final state = ref.read(warehousesVmProvider);
      if (state is AdminCrudData<WarehouseRow>) {
        for (final wh in state.items) {
          if (wh.id == parentId) return wh.name;
        }
      }
      return 'ID: $parentId';
    }();

    showDialog(
      context: context,
      builder: (_) => _WarehouseDetails(
        item: w,
        branchName: branchName,
        parentWarehouseName: parentWarehouseName,
      ),
    );
  }
}

class _WarehouseCard extends StatelessWidget {
  final WarehouseRow warehouse;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WarehouseCard({
    required this.warehouse,
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
              AdminStatusBadge(isActive: warehouse.isActive),
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

class _WarehouseDetails extends StatelessWidget {
  final WarehouseRow item;
  final String branchName;
  final String parentWarehouseName;

  const _WarehouseDetails({
    required this.item,
    required this.branchName,
    required this.parentWarehouseName,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'Warehouse Details',
      id: item.id.toString(),
      icon: Icons.warehouse_rounded,
      children: [
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (EN)', item.name, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (AR)', item.nameAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Code', item.code ?? 'N/A', Icons.qr_code_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Branch', branchName, Icons.storefront_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Parent Warehouse', parentWarehouseName, Icons.account_tree_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Notes', (item.notes?.isNotEmpty == true) ? item.notes! : 'N/A', Icons.note_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Address', item.location ?? 'N/A', Icons.location_on_rounded),
        AdminDetailsDialog.buildDetailRow(context, 'Phone', item.phone ?? 'N/A', Icons.phone_rounded),
        const SizedBox(height: 12),
        AdminDetailsDialog.buildStatusRow(context, item.isActive),
      ],
    );
  }
}
