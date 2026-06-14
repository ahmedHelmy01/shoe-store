import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/data/models/category_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

class CategoriesTable extends StatelessWidget {
  final AdminCrudData<CategoryRow> state;
  final Function(CategoryRow c) onEdit;
  final Function(int id) onDelete;
  final VoidCallback? onNextPage;
  final VoidCallback? onPrevPage;
  final ValueChanged<String>? onSearch;
  final ValueChanged<int>? onServerPageSize;
  final Widget Function(BuildContext context, CategoryRow c)? cardBuilder;

  const CategoriesTable({
    super.key,
    required this.state,
    required this.onEdit,
    required this.onDelete,
    this.onNextPage,
    this.onPrevPage,
    this.onSearch,
    this.onServerPageSize,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CategoryRow>(
      isServerSide: true,
      serverPage: state.page,
      serverLastPage: state.lastPage ?? 1,
      serverTotal: state.total ?? state.items.length,
      onNextPage: state.canNext ? onNextPage : null,
      onPrevPage: state.canPrev ? onPrevPage : null,
      onSearch: onSearch,
      onServerPageSize: onServerPageSize,
      initialSearchQuery: state.search,
      initialPageSize: state.perPage,
      rows: state.items,
      idOf: (c) => '${c.id}',
      exportBaseName: 'categories',
      searchHint: 'Search categories by name or code…',
      searchText: (c) => '${c.id} ${c.code ?? ''} ${c.name} ${c.nameEn ?? ''} ${c.nameAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<CategoryRow>(
          title: 'ID',
          sortable: true,
          sortValue: (c) => c.id,
          exportValue: (c) => '${c.id}',
          cell: (_, c) => Text('${c.id}'),
          width: 80,
        ),
        AdminColumn<CategoryRow>(
          title: 'Name',
          sortable: true,
          sortValue: (c) => c.name,
          exportValue: (c) => c.name,
          cell: (_, c) => Row(
            children: [
              if (c.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      c.imageUrl!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          width: 200,
        ),
        AdminColumn<CategoryRow>(
          title: 'English Name',
          sortable: true,
          sortValue: (c) => c.nameEn ?? '',
          exportValue: (c) => c.nameEn ?? '',
          cell: (_, c) => Text(c.nameEn ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 200,
        ),
        AdminColumn<CategoryRow>(
          title: 'Code',
          sortable: true,
          sortValue: (c) => c.code ?? '',
          exportValue: (c) => c.code ?? '',
          cell: (_, c) => Text(c.code ?? '-'),
          width: 120,
        ),
        AdminColumn<CategoryRow>(
          title: 'Status',
          sortable: true,
          sortValue: (c) => c.isActive ? 1 : 0,
          exportValue: (c) => c.isActive ? 'Active' : 'Inactive',
          cell: (_, c) => AdminStatusBadge(isActive: c.isActive),
          width: 100,
        ),
        AdminColumn<CategoryRow>(
          title: 'Actions',
          cell: (_, c) => AdminTableActionsCell<CategoryRow>(
            row: c,
            onView: (c) {
              showDialog(
                context: context,
                builder: (context) => CategoryDetailsDialog(category: c),
              );
            },
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
            confirmBeforeDelete: false,
          ),
          width: 130,
        ),
      ],
    );
  }
}

class CategoryDetailsDialog extends StatelessWidget {
  final CategoryRow category;

  const CategoryDetailsDialog({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AdminDetailsDialog(
      title: 'Category Details',
      id: category.id.toString(),
      icon: Icons.category_rounded,
      maxWidth: 600,
      children: [
        // Category Image
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: category.imageUrl != null
                ? Image.network(
                    category.imageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildImagePlaceholder(isDark),
                  )
                : _buildImagePlaceholder(isDark),
          ),
        ),

        // Row 1: Name (English) + Name (Arabic)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context, 'Name (English)', category.nameEn ?? category.name, Icons.language_rounded),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context, 'Name (Arabic)', category.nameAr ?? 'N/A', Icons.translate_rounded),
            ),
          ],
        ),

        // Row 2: Code + Parent ID
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context, 'Code', category.code ?? 'N/A', Icons.qr_code_rounded),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context, 'Parent ID', category.parentId?.toString() ?? 'None', Icons.account_tree_rounded),
            ),
          ],
        ),

        // Row 3: Description (English) + Description (Arabic)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context, 'Description (English)', category.descriptionEn ?? 'N/A', Icons.description_rounded),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context, 'Description (Arabic)', category.descriptionAr ?? 'N/A', Icons.description_rounded),
            ),
          ],
        ),

        // Status row
        AdminDetailsDialog.buildStatusRow(context, category.isActive),
      ],
    );
  }

  Widget _buildImagePlaceholder(bool isDark) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          Text(
            'No Image',
            style: TextStyle(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.3),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
