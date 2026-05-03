import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

class ProductsTable extends StatelessWidget {
  final AdminCrudData<ProductRow> state;
  final Function(ProductRow p) onEdit;
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
            onView: (p) {
              showDialog(
                context: context,
                builder: (context) => ProductDetailsDialog(product: p),
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
        if (product.image != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              product.image!,
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
        AdminDetailsDialog.buildDetailRow(context, 'Name', product.name, Icons.title_rounded),
        if (product.code != null)
          AdminDetailsDialog.buildDetailRow(context, 'Code', product.code!, Icons.qr_code_rounded),
        AdminDetailsDialog.buildDetailRow(context, 'SKU', product.sku, Icons.tag_rounded),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Sale Price', '${product.salePrice ?? '0'} EGP', Icons.sell_rounded)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Purchase Price', '${product.purchasePrice ?? '0'} EGP', Icons.shopping_cart_rounded)),
          ],
        ),
        AdminDetailsDialog.buildDetailRow(context, 'Description (EN)', product.description ?? 'N/A', Icons.description_rounded),
        AdminDetailsDialog.buildDetailRow(context, 'Description (AR)', product.descriptionAr ?? 'N/A', Icons.description_rounded),
        const SizedBox(height: 12),
        AdminDetailsDialog.buildStatusRow(context, product.isActive),
      ],
    );
  }
}


