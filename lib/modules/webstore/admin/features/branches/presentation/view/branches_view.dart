import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_card_popup_menu.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
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
                title: AdminLocalizations.translate(context, 'business branches'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'add branch'),
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
            title: state.isAdding ? AdminLocalizations.translate(context, 'create branch') : AdminLocalizations.translate(context, 'edit branch'),
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
                    title: state.isAdding ? AdminLocalizations.translate(context, 'branch created') : AdminLocalizations.translate(context, 'branch updated'),
                    message: AdminLocalizations.translate(context, 'the branch has been saved successfully.'),
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: AdminLocalizations.translate(context, 'save failed'),
                    message: AdminLocalizations.translate(context, 'an error occurred while saving the branch.'),
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
      title: AdminLocalizations.translate(context, 'delete branch'),
      message: '${AdminLocalizations.translate(context, 'are you sure you want to delete branch')} "$name"?',
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
            message: AdminLocalizations.translate(context, 'branch deleted successfully.'),
          );
        } else {
          AppStatusDialog.show(
            context,
            status: AppDialogStatus.error,
            title: AdminLocalizations.translate(context, 'delete failed'),
            message: AdminLocalizations.translate(context, 'could not delete the branch. please try again.'),
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
                      branch.nameAr ?? AdminLocalizations.translate(context, 'no arabic name'),
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
                activeLabel: AdminLocalizations.translate(context, 'open'),
                inactiveLabel: AdminLocalizations.translate(context, 'closed'),
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
      title: AdminLocalizations.translate(context, 'branch details'),
      id: item.id.toString(),
      icon: Icons.storefront_rounded,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (en)'), item.name, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (ar)'), item.nameAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'code'), item.code ?? AdminLocalizations.translate(context, 'n/a'), Icons.qr_code_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'phone'), item.phone ?? AdminLocalizations.translate(context, 'n/a'), Icons.phone_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'email'), item.email ?? AdminLocalizations.translate(context, 'n/a'), Icons.email_rounded),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'address (english)'), item.address ?? AdminLocalizations.translate(context, 'n/a'), Icons.location_on_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'address (arabic)'), item.addressAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.location_on_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'city'), item.city ?? AdminLocalizations.translate(context, 'n/a'), Icons.location_city_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'country'), item.country ?? AdminLocalizations.translate(context, 'n/a'), Icons.public_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'latitude'), item.latitude?.toString() ?? AdminLocalizations.translate(context, 'n/a'), Icons.map_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'longitude'), item.longitude?.toString() ?? AdminLocalizations.translate(context, 'n/a'), Icons.map_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'description'), item.description ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'description (arabic)'), item.descriptionAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'type'), item.isMain ? AdminLocalizations.translate(context, 'main branch') : AdminLocalizations.translate(context, 'standard branch'), Icons.info_outline_rounded),
        const SizedBox(height: 12),
        AdminDetailsDialog.buildStatusRow(context, item.isActive),
      ],
    );
  }
}
