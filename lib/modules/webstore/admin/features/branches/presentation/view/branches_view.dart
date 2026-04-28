import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
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
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

class BranchesView extends ConsumerStatefulWidget {
  const BranchesView({super.key});

  @override
  ConsumerState<BranchesView> createState() => _BranchesViewState();
}

class _BranchesViewState extends ConsumerState<BranchesView> {

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
                final result = await notifier.commitSave(data, id: state.editingItem?.id);
                if (!mounted) return;
                
                if (result) {
                  notifier.closePanel();
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: state.isAdding ? 'Branch Created' : 'Branch Updated',
                    message: 'The branch has been saved successfully.',
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: 'Save Failed',
                    message: 'An error occurred while saving the branch.',
                  );
                }
              },
            ),
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
            child: BranchesTable(
              items: items,
              onView: (b) => showDialog(context: context, builder: (_) => _BranchDetails(item: b)),
              onEdit: (b) => notifier.openEdit(b),
              onDelete: (id) => _confirmAndDelete(context, notifier, id, items.firstWhere((b) => b.id == id).name),
              cardBuilder: (context, b) => _BranchCard(
                branch: b,
                onView: () => showDialog(context: context, builder: (_) => _BranchDetails(item: b)),
                onEdit: () => notifier.openEdit(b),
                onDelete: () => _confirmAndDelete(context, notifier, b.id, b.name),
              ),
            ),
          ),
        ),
    };
  }

  void _confirmAndDelete(BuildContext context, BranchesVm notifier, int id, String name) {
    AppDialog.show(
      context,
      title: 'Delete Branch',
      message: 'Are you sure you want to delete branch "$name"?',
      cancelText: 'Cancel',
      confirmText: 'Delete',
      onConfirm: () async {
        Navigator.pop(context);
        final success = await notifier.commitDelete(id);
        if (!context.mounted) return;
        if (success) {
          AppStatusDialog.show(
            context,
            status: AppDialogStatus.success,
            title: 'Deleted',
            message: 'Branch deleted successfully.',
          );
        } else {
          AppStatusDialog.show(
            context,
            status: AppDialogStatus.error,
            title: 'Delete Failed',
            message: 'Could not delete the branch. Please try again.',
          );
        }
      },
    );
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
              AdminStatusBadge(
                isActive: branch.isActive,
                activeLabel: 'Open',
                inactiveLabel: 'Closed',
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
    return AdminDetailsDialog(
      title: 'Branch Details',
      id: item.id.toString(),
      icon: Icons.storefront_rounded,
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
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Phone', item.phone ?? 'N/A', Icons.phone_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Email', item.email ?? 'N/A', Icons.email_rounded),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Address (EN)', item.address ?? 'N/A', Icons.location_on_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Address (AR)', item.addressAr ?? 'N/A', Icons.location_on_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'City', item.city ?? 'N/A', Icons.location_city_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Country', item.country ?? 'N/A', Icons.public_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Latitude', item.latitude?.toString() ?? 'N/A', Icons.map_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Longitude', item.longitude?.toString() ?? 'N/A', Icons.map_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Description (EN)', item.description ?? 'N/A', Icons.description_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Description (AR)', item.descriptionAr ?? 'N/A', Icons.description_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Type', item.isMain ? 'Main Branch' : 'Standard Branch', Icons.info_outline_rounded),
        const SizedBox(height: 12),
        AdminDetailsDialog.buildStatusRow(context, item.isActive),
      ],
    );
  }
}
