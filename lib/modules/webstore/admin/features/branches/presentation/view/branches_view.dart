import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_action_icon_button.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_panel.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import '../view_model/branches_view_model.dart';
import '../widgets/branches_table.dart';
import '../widgets/branch_form.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';

class BranchesView extends ConsumerStatefulWidget {
  const BranchesView({super.key});

  @override
  ConsumerState<BranchesView> createState() => _BranchesViewState();
}

class _BranchesViewState extends ConsumerState<BranchesView> {
  BranchRow? _detailsItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(branchesVmProvider);
    final notifier = ref.read(branchesVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: 'Business Branches',
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: 'Add Branch',
                onPrimaryAction: () {
                  setState(() => _detailsItem = null);
                  notifier.openAdd();
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
            title: state.isAdding ? 'Create Branch' : 'Edit Branch',
            size: AdminDialogSize.medium,
            child: BranchForm(
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
            title: 'Branch Details',
            size: AdminDialogSize.small,
            customHeightFactor: 0.74,
            child: _BranchDetails(item: _detailsItem!),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<BranchRow> state, bool isDark, BranchesVm notifier) {
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
            child: BranchesTable(
              items: items,
              onView: (b) => setState(() => _detailsItem = b),
              onEdit: (b) => notifier.openEdit(b),
              onDelete: (id) => notifier.commitDelete(id),
              cardBuilder: (context, b) => _BranchCard(
                branch: b,
                onView: () => setState(() => _detailsItem = b),
                onEdit: () => notifier.openEdit(b),
                onDelete: () => notifier.commitDelete(b.id),
              ),
            ),
          ),
        ),
    };
  }
}

class _BranchCard extends StatelessWidget {
  final BranchRow branch;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BranchCard({
    required this.branch,
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
                      branch.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      branch.nameAr ?? 'No Arabic name',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
                    ),
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
              if (branch.phone != null)
                Row(
                  children: [
                    Icon(Icons.phone_rounded, size: 14, color: theme.primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      branch.phone!,
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (branch.isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
                ),
                child: Text(
                  branch.isActive ? 'Open' : 'Closed',
                  style: theme.textTheme.labelSmall?.copyWith(color: branch.isActive ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BranchDetails extends StatelessWidget {
  final BranchRow item;

  const _BranchDetails({required this.item});

  @override
  Widget build(BuildContext context) {
    final entries = <MapEntry<String, String>>[
      MapEntry('ID', item.id.toString()),
      MapEntry('Name', item.name),
      MapEntry('Name (Arabic)', item.nameAr ?? '-'),
      MapEntry('Code', item.code ?? '-'),
      MapEntry('Phone', item.phone ?? '-'),
      MapEntry('Email', item.email ?? '-'),
      MapEntry('Address', item.address ?? '-'),
      MapEntry('Address (Arabic)', item.addressAr ?? '-'),
      MapEntry('Latitude', item.latitude?.toString() ?? '-'),
      MapEntry('Longitude', item.longitude?.toString() ?? '-'),
      MapEntry('Active', item.isActive ? 'Yes' : 'No'),
    ];

    return AdminDetailsPanel(
      title: item.name,
      idText: '#${item.id}',
      headerIcon: Icons.storefront_rounded,
      entries: entries,
    );
  }
}
