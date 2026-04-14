import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';

class ProductsTable extends StatelessWidget {
  final List<ProductRow> items;
  final Function(ProductRow p) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, ProductRow p)? cardBuilder;

  const ProductsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<ProductRow>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'products',
      searchHint: 'Search products…',
      searchText: (p) => '${p.id} ${p.name} ${p.sku}',
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
          title: 'Name',
          sortable: true,
          sortValue: (p) => p.name,
          exportValue: (p) => p.name,
          cell: (_, p) => Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
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
          title: 'Price',
          sortable: true,
          sortValue: (p) => p.price ?? 0.0,
          exportValue: (p) => '${p.price ?? ''}',
          cell: (_, p) => Text(p.price != null ? '\$${p.price}' : '-'),
          width: 100,
        ),
        AdminColumn<ProductRow>(
          title: 'Status',
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? 'Active' : 'Inactive',
          cell: (_, p) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (p.isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              p.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: p.isActive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          width: 100,
        ),
        AdminColumn<ProductRow>(
          title: 'Actions',
          cell: (_, p) => Row(
            children: [
              IconButton(onPressed: () => onEdit(p), icon: const Icon(Icons.edit_outlined, size: 20)),
              IconButton(onPressed: () => onDelete(p.id), icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red)),
            ],
          ),
          width: 110,
        ),
      ],
    );
  }
}
