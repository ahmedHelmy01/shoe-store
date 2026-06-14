import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

class ProductsTable extends StatelessWidget {
  final AdminCrudData<ProductRow> state;
  final Function(ProductRow p) onEdit;
  final Function(ProductRow p) onView;
  final Function(int id) onDelete;
  final VoidCallback? onNextPage;
  final VoidCallback? onPrevPage;
  final ValueChanged<String>? onSearch;
  final ValueChanged<int>? onServerPageSize;
  final Widget Function(BuildContext context, ProductRow p)? cardBuilder;

  const ProductsTable({
    super.key,
    required this.state,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
    this.onNextPage,
    this.onPrevPage,
    this.onSearch,
    this.onServerPageSize,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<ProductRow>(
      isServerSide: true,
      serverPage: state.page,
      serverLastPage: state.lastPage ?? 1,
      serverTotal: state.total ?? 0,
      onNextPage: state.canNext ? onNextPage : null,
      onPrevPage: state.canPrev ? onPrevPage : null,
      onSearch: onSearch,
      onServerPageSize: onServerPageSize,
      initialSearchQuery: state.search,
      initialPageSize: state.perPage,
      rows: state.items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'products',
      searchHint: 'Search by name or code…',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<ProductRow>(
          title: 'ID',
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<ProductRow>(
          title: 'Product',
          sortable: true,
          sortValue: (p) => p.name,
          exportValue: (p) => p.name,
          cell: (_, p) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                p.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (p.code != null)
                Text(
                  p.code!,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
            ],
          ),
          width: 250,
        ),
        AdminColumn<ProductRow>(
          title: 'SKU',
          sortable: true,
          sortValue: (p) => p.sku,
          exportValue: (p) => p.sku,
          cell: (_, p) => Text(p.sku, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          width: 150,
        ),
        AdminColumn<ProductRow>(
          title: 'Sale Price',
          sortable: true,
          sortValue: (p) => double.tryParse(p.salePrice ?? '0') ?? 0,
          exportValue: (p) => p.salePrice ?? '0',
          cell: (_, p) => Text(p.salePrice != null ? '${p.salePrice} EGP' : '-'),
          width: 120,
        ),
        AdminColumn<ProductRow>(
          title: 'Status',
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? 'Active' : 'Inactive',
          cell: (_, p) => AdminStatusBadge(isActive: p.isActive),
          width: 100,
        ),
        AdminColumn<ProductRow>(
          title: 'Actions',
          cell: (context, p) => AdminTableActionsCell<ProductRow>(
            row: p,
            onView: onView,
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

class ProductDetailsDialog extends StatelessWidget {
  final ProductRow product;

  const ProductDetailsDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'Product Details',
      id: product.id.toString(),
      icon: Icons.inventory_2_rounded,
      children: [
        if (product.imageUrl != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              product.imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (product.imageUrls != null && product.imageUrls!.isNotEmpty) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.collections_rounded, size: 20, color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withValues(alpha: 0.4)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gallery Images',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.imageUrls!.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final url = product.imageUrls![index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              url,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported, size: 20),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        // Name (EN) + Name (AR)
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (EN)', product.nameEn ?? product.name, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (AR)', product.nameAr ?? 'N/A', Icons.title_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        // SKU + Code
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'SKU', product.sku, Icons.tag_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Code', product.code ?? 'N/A', Icons.qr_code_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        // Sale Price + Purchase Price
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Sale Price', '${product.salePrice ?? '0'} EGP', Icons.sell_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Purchase Price', '${product.purchasePrice ?? '0'} EGP', Icons.shopping_cart_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        // Description EN + Description AR
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Description (EN)', product.description ?? 'N/A', Icons.description_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Description (AR)', product.descriptionAr ?? 'N/A', Icons.description_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        // Tags + Properties
        if ((product.tags != null && product.tags!.isNotEmpty) || (product.properties != null && product.properties!.isNotEmpty)) ...[
          Row(
            children: [
              if (product.tags != null && product.tags!.isNotEmpty)
                Expanded(
                  child: _buildBadgesRow(
                    context,
                    'Tags',
                    product.tags!.map((t) => t.nameAr ?? t.name).toList(),
                    Icons.label_important_outline_rounded,
                    Theme.of(context).primaryColor,
                    bottomPadding: 0,
                  ),
                ),
              if (product.tags != null && product.tags!.isNotEmpty &&
                  product.properties != null && product.properties!.isNotEmpty)
                const SizedBox(width: 16),
              if (product.properties != null && product.properties!.isNotEmpty)
                Expanded(
                  child: _buildBadgesRow(
                    context,
                    'Properties',
                    product.properties!.map((p) => p.titleAr ?? p.title).toList(),
                    Icons.settings_input_component_rounded,
                    Colors.blue,
                    bottomPadding: 0,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
        // Status
        AdminDetailsDialog.buildStatusRow(context, product.isActive),
      ],
    );
  }

  Widget _buildBadgesRow(BuildContext context, String label, List<String> values, IconData icon, Color color, {double bottomPadding = 20}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.4)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: values.map((v) => _buildBadge(context, v, color)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? color.withValues(alpha: 0.9) : color.withValues(alpha: 0.8),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}




