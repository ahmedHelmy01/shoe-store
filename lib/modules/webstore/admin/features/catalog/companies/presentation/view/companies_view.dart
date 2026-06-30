import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../view_model/companies_view_model.dart';
import '../widgets/companies_table.dart';
import '../widgets/company_form.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';

class CompaniesView extends ConsumerWidget {
  const CompaniesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(companiesVmProvider);
    final notifier = ref.read(companiesVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'brands & companies'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'add company'),
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
            title: state.isAdding ? AdminLocalizations.translate(context, 'add company') : AdminLocalizations.translate(context, 'edit company'),
            size: AdminDialogSize.medium,
            child: CompanyForm(
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data, imageFile) async {
                final isSuccess = await notifier.commitSave(
                  data,
                  id: state.editingItem?.id,
                  imageFile: imageFile,
                );
                if (!context.mounted) return;

                if (isSuccess) {
                  notifier.closePanel();
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: state.isAdding ? AdminLocalizations.translate(context, 'company added') : AdminLocalizations.translate(context, 'company updated'),
                    message: AdminLocalizations.translate(context, 'the company has been saved successfully.'),
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: AdminLocalizations.translate(context, 'save failed'),
                    message: AdminLocalizations.translate(context, 'failed to save company. please try again.'),
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
    AdminCrudState<CompanyRow> state,
    bool isDark,
    CompaniesVm notifier,
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
          child: CompaniesTable(
            items: items,
            onEdit: (c) => notifier.openEdit(c),
            onDelete: (id) => _confirmAndDelete(
              context,
              notifier,
              id,
              items.firstWhere((c) => c.id == id).name,
            ),
            cardBuilder: (context, c) => _CompanyCard(
              company: c,
              onView: () => _showDetails(context, c),
              onEdit: () => notifier.openEdit(c),
              onDelete: () =>
                  _confirmAndDelete(context, notifier, c.id, c.name),
            ),
          ),
        ),
      ),
    };
  }

  void _showDetails(BuildContext context, CompanyRow c) {
    showDialog(
      context: context,
      builder: (context) => AdminDetailsDialog(
        title: AdminLocalizations.translate(context, 'company details'),
        id: c.id.toString(),
        icon: Icons.business_rounded,
        children: [
          Row(
            children: [
              Expanded(
                child: AdminDetailsDialog.buildDetailRow(
                  context,
                  AdminLocalizations.translate(context, 'name (english)'),
                  c.name,
                  Icons.language_rounded,
                  bottomPadding: 0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AdminDetailsDialog.buildDetailRow(
                  context,
                  AdminLocalizations.translate(context, 'name (arabic)'),
                  c.nameAr ?? AdminLocalizations.translate(context, 'n/a'),
                  Icons.translate_rounded,
                  bottomPadding: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AdminDetailsDialog.buildDetailRow(
                  context,
                  AdminLocalizations.translate(context, 'description (english)'),
                  c.description?.isNotEmpty == true ? c.description! : AdminLocalizations.translate(context, 'n/a'),
                  Icons.description_rounded,
                  bottomPadding: 0,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AdminDetailsDialog.buildDetailRow(
                  context,
                  AdminLocalizations.translate(context, 'description (arabic)'),
                  c.descriptionAr?.isNotEmpty == true ? c.descriptionAr! : AdminLocalizations.translate(context, 'n/a'),
                  Icons.description_outlined,
                  bottomPadding: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AdminDetailsDialog.buildStatusRow(context, c.isActive),
        ],
      ),
    );
  }

  void _confirmAndDelete(
    BuildContext context,
    CompaniesVm notifier,
    int id,
    String name,
  ) {
    AppDialog.show(
      context,
      title: AdminLocalizations.translate(context, 'delete company'),
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
            message: AdminLocalizations.translate(context, 'company deleted successfully.'),
          );
        } else {
          AppStatusDialog.show(
            context,
            status: AppDialogStatus.error,
            title: AdminLocalizations.translate(context, 'delete failed'),
            message: AdminLocalizations.translate(context, 'could not delete company. please try again.'),
          );
        }
      },
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyRow company;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CompanyCard({
    required this.company,
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
                child: Text(
                  company.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: onView,
                    child: Row(
                      children: [
                        const Icon(Icons.visibility_outlined),
                        const SizedBox(width: 8),
                        Text(AdminLocalizations.translate(context, 'details')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: onEdit,
                    child: Row(
                      children: [
                        const Icon(Icons.edit_outlined),
                        const SizedBox(width: 8),
                        Text(AdminLocalizations.translate(context, 'edit')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline_rounded, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(AdminLocalizations.translate(context, 'delete')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdminStatusBadge(isActive: company.isActive),
              Text(
                'ID: ${company.id}',
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
