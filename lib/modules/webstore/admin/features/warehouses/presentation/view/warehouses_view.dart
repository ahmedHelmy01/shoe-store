import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';
import 'package:erp/modules/webstore/admin/features/branches/presentation/view_model/branches_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_action_icon_button.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_panel.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';

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
  WarehouseRow? _detailsItem;

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
                  setState(() => _detailsItem = null);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    print('[WAREHOUSE_UI] postFrame -> openAdd()');
                    notifier.openAdd();
                  });
                },
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
            closeOnBackdropTap: false,
            child: WarehouseForm(
              key: ValueKey(state.isAdding ? 'warehouse-add' : 'warehouse-edit-${state.editingItem?.id ?? 0}'),
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                if (await notifier.commitSave(data, id: state.editingItem?.id)) {
                  notifier.closePanel();
                }
              },
            ),
          ),
        if (_detailsItem != null)
          AdminDialogForm(
            isOpen: true,
            onClose: () => setState(() => _detailsItem = null),
            title: 'Warehouse Details',
            size: AdminDialogSize.small,
            customHeightFactor: 0.70,
            closeOnBackdropTap: true,
            child: _WarehouseDetails(
              item: _detailsItem!,
              branchName: () {
                final branchId = _detailsItem!.branchId;
                if (branchId == null) return '-';
                for (final branch in branches) {
                  if (branch.id == branchId) return branch.name;
                }
                return '-';
              }(),
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
              onView: (w) => setState(() => _detailsItem = w),
              onDelete: (w) => _confirmAndDelete(context, notifier, w),
              cardBuilder: (context, w) => _WarehouseCard(
                warehouse: w,
                onView: () => setState(() => _detailsItem = w),
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
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: onView,
                    child: Row(
                      children: [
                        HugeIcon(
                          icon: AdminActionIconButton.iconOf(AdminActionIconType.view),
                          color: AdminActionIconButton.colorOf(AdminActionIconType.view),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text('Details'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: onEdit,
                    child: Row(
                      children: [
                        HugeIcon(
                          icon: AdminActionIconButton.iconOf(AdminActionIconType.edit),
                          color: AdminActionIconButton.colorOf(AdminActionIconType.edit),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: Row(
                      children: [
                        HugeIcon(
                          icon: AdminActionIconButton.iconOf(AdminActionIconType.delete),
                          color: AdminActionIconButton.colorOf(AdminActionIconType.delete),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text('Delete'),
                      ],
                    ),
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

class _WarehouseDetails extends StatelessWidget {
  final WarehouseRow item;
  final String branchName;

  const _WarehouseDetails({
    required this.item,
    required this.branchName,
  });

  @override
  Widget build(BuildContext context) {
    final entries = <MapEntry<String, String>>[
      MapEntry('ID', item.id.toString()),
      MapEntry('Name', item.name),
      MapEntry('Name (Arabic)', item.nameAr ?? '-'),
      MapEntry('Code', item.code ?? '-'),
      MapEntry('Branch', branchName),
      MapEntry('Address', item.location ?? '-'),
      MapEntry('Phone', item.phone ?? '-'),
      MapEntry('Active', item.isActive ? 'Yes' : 'No'),
    ];

    return AdminDetailsPanel(
      title: item.name,
      idText: '#${item.id}',
      headerIcon: Icons.warehouse_rounded,
      entries: entries,
    );
  }
}
