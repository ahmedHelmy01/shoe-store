import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../view_model/categories_view_model.dart';
import '../widgets/categories_table.dart';
import '../widgets/category_form.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(categoriesVmProvider);
    final notifier = ref.read(categoriesVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'categories'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'add category'),
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
            title: state.isAdding ? AdminLocalizations.translate(context, 'add category') : AdminLocalizations.translate(context, 'edit category'),
            size: AdminDialogSize.medium,
            child: CategoryForm(
              initial: state.editingItem,
              isSaving: state.isSaving,
              uploadProgress: state.uploadProgress,
              categories: state is AdminCrudData ? (state as AdminCrudData<CategoryRow>).items : [],
              onSave: (data, imageFile) async {
                final result = await notifier.commitSave(data, id: state.editingItem?.id, imageFile: imageFile);
                if (!context.mounted) return;
                
                if (result) {
                  notifier.closePanel();
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: state.isAdding ? AdminLocalizations.translate(context, 'category added') : AdminLocalizations.translate(context, 'category updated'),
                    message: AdminLocalizations.translate(context, 'the category was saved successfully.'),
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: AdminLocalizations.translate(context, 'save failed'),
                    message: AdminLocalizations.translate(context, 'an error occurred while saving the category.'),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<CategoryRow> state, bool isDark, CategoriesVm notifier) {
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
            child: CategoriesTable(
              state: state,
              onNextPage: () => notifier.nextPage(),
              onPrevPage: () => notifier.prevPage(),
              onSearch: (q) => notifier.fetch(search: q, page: 1),
              onServerPageSize: (size) => notifier.fetch(perPage: size, page: 1),
              onEdit: (c) => notifier.openEdit(c),
              onDelete: (id) => _confirmAndDelete(context, notifier, id, items.firstWhere((c) => c.id == id).name),
              cardBuilder: (context, c) => _CategoryCard(
                category: c,
                onView: () {
                  showDialog(
                    context: context,
                    builder: (context) => CategoryDetailsDialog(category: c),
                  );
                },
                onEdit: () => notifier.openEdit(c),
                onDelete: () => _confirmAndDelete(context, notifier, c.id, c.name),
              ),
            ),
          ),
        ),
    };
  }

  void _confirmAndDelete(BuildContext context, CategoriesVm notifier, int id, String name) {
    AppDialog.show(
      context,
      title: AdminLocalizations.translate(context, 'delete category'),
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
            message: AdminLocalizations.translate(context, 'category deleted successfully.'),
          );
        } else {
          AppStatusDialog.show(
            context,
            status: AppDialogStatus.error,
            title: AdminLocalizations.translate(context, 'delete failed'),
            message: AdminLocalizations.translate(context, 'could not delete the category. please try again.'),
          );
        }
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryRow category;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
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
              if (category.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      category.imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AdminLocalizations.translate(context, 'code:')} ${category.code ?? AdminLocalizations.translate(context, 'none')}',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: onView,
                    child: Row(children: [const Icon(Icons.visibility_outlined, color: Colors.blue), const SizedBox(width: 8), Text(AdminLocalizations.translate(context, 'view details'))]),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdminStatusBadge(isActive: category.isActive),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.primaryColor.withValues(alpha: 0.1),
                ),
                child: Text(
                  'ID: ${category.id}',
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
