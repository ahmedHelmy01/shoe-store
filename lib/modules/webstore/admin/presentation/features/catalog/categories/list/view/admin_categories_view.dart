import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/presentation/common/table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/presentation/models/admin_fake_data.dart';
import 'package:erp/modules/webstore/catalog/data/models/category_model.dart';

class AdminCategoriesView extends StatelessWidget {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final items = AdminFakeData.categories();

    final box = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
      ),
      child: isWide
          ? AdminDataTable<WebStoreCategory>(
              rows: items,
              idOf: (c) => '${c.id ?? c.name}',
              exportBaseName: 'categories',
              searchHint: 'Search categories…',
              searchText: (c) => '${c.id ?? ''} ${c.name} ${c.description ?? ''} ${c.parentId ?? ''}',
              columns: [
                AdminColumn<WebStoreCategory>(
                  title: 'ID',
                  sortable: true,
                  sortValue: (c) => c.id ?? 0,
                  exportValue: (c) => '${c.id ?? ''}',
                  cell: (_, c) => Text('${c.id ?? ''}'),
                  width: 80,
                ),
                AdminColumn<WebStoreCategory>(
                  title: 'Name',
                  sortable: true,
                  sortValue: (c) => c.name,
                  exportValue: (c) => c.name,
                  cell: (_, c) => Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  width: 300,
                ),
                AdminColumn<WebStoreCategory>(
                  title: 'Parent',
                  sortable: true,
                  sortValue: (c) => c.parentId ?? 0,
                  exportValue: (c) => c.parentId?.toString() ?? '',
                  cell: (_, c) => Text(c.parentId?.toString() ?? '-'),
                  width: 120,
                ),
                AdminColumn<WebStoreCategory>(
                  title: 'Products',
                  sortable: true,
                  sortValue: (c) => c.productsCount ?? 0,
                  exportValue: (c) => c.productsCount?.toString() ?? '',
                  cell: (_, c) => Text('${c.productsCount ?? '-'}'),
                  width: 120,
                ),
                AdminColumn<WebStoreCategory>(
                  title: 'Active',
                  sortable: true,
                  sortValue: (c) => (c.isActive ?? true) ? 1 : 0,
                  exportValue: (c) => (c.isActive ?? true) ? 'Yes' : 'No',
                  cell: (_, c) => Text((c.isActive ?? true) ? 'Yes' : 'No'),
                  width: 110,
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
              ),
              itemBuilder: (context, i) {
                final c = items[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                    child: const Icon(Icons.account_tree_rounded),
                  ),
                  title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Parent: ${c.parentId ?? '-'} • Products: ${c.productsCount ?? '-'}'),
                );
              },
            ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Categories',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: () {},
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AppAnimation.fadeInUp(
              duration: const Duration(milliseconds: 420),
              child: box,
            ),
          ),
        ],
      ),
    );
  }
}

