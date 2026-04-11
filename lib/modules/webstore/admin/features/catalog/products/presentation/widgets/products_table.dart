import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductsTable extends StatelessWidget {
  final List<WebStoreProduct> items;

  const ProductsTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<WebStoreProduct>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'products',
      searchHint: 'Search products…',
      searchText: (p) => '${p.id} ${p.name} ${p.sku}',
      columns: [
        AdminColumn<WebStoreProduct>(
          title: 'ID',
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<WebStoreProduct>(
          title: 'Image',
          cell: (_, p) => Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.withValues(alpha: 0.1),
            ),
            clipBehavior: Clip.antiAlias,
            child: p.images.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: p.images.first,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))),
                    errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported_rounded, size: 16),
                  )
                : const Icon(Icons.image_rounded, size: 20),
          ),
          width: 80,
        ),
        AdminColumn<WebStoreProduct>(
          title: 'Name',
          sortable: true,
          sortValue: (p) => p.name,
          exportValue: (p) => p.name,
          cell: (_, p) => Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 300,
        ),
        AdminColumn<WebStoreProduct>(
          title: 'Price',
          sortable: true,
          sortValue: (p) => p.price,
          exportValue: (p) => '${p.price}',
          cell: (_, p) => Text('${p.price}'),
          width: 100,
        ),
        AdminColumn<WebStoreProduct>(
          title: 'Stock',
          sortable: true,
          sortValue: (p) => p.stock,
          exportValue: (p) => '${p.stock}',
          cell: (_, p) => Text('${p.stock}'),
          width: 100,
        ),
      ],
    );
  }
}
