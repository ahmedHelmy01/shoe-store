import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_state.dart';
import 'package:erp/modules/webstore/admin/presentation/view_model/admin_products_view_model.dart';
import 'package:erp/modules/webstore/admin/presentation/common/table/admin_data_table.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';

class AdminProductsView extends ConsumerStatefulWidget {
  const AdminProductsView({super.key});

  @override
  ConsumerState<AdminProductsView> createState() => _AdminProductsViewState();
}

class _AdminProductsViewState extends ConsumerState<AdminProductsView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProductsVmProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Products',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: () => ref.read(adminProductsVmProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: switch (state) {
              AdminProductsLoading() => const Center(child: CircularProgressIndicator()),
              AdminProductsError(:final message) => _ErrorBox(message: message),
              AdminProductsData() => _ProductsBody(data: state as AdminProductsData),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

class _ProductsBody extends ConsumerWidget {
  final AdminProductsData data;
  const _ProductsBody({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    final items = data.items.whereType<WebStoreProduct>().toList(growable: false);

    final box = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
      ),
      child: isWide
          ? AdminDataTable<WebStoreProduct>(
              rows: items,
              idOf: (p) => '${p.id ?? p.name}',
              exportBaseName: 'products',
              searchHint: 'Search inside table…',
              searchText: (p) => '${p.id ?? ''} ${p.name} ${p.brand ?? ''} ${p.price} ${p.stock ?? ''}',
              columns: [
                AdminColumn<WebStoreProduct>(
                  title: 'ID',
                  sortable: true,
                  sortValue: (p) => p.id ?? 0,
                  exportValue: (p) => '${p.id ?? ''}',
                  cell: (_, p) => Text('${p.id ?? ''}'),
                  width: 70,
                ),
                AdminColumn<WebStoreProduct>(
                  title: 'Name',
                  sortable: true,
                  sortValue: (p) => p.name,
                  exportValue: (p) => p.name,
                  cell: (_, p) => Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  width: 280,
                ),
                AdminColumn<WebStoreProduct>(
                  title: 'Price',
                  sortable: true,
                  sortValue: (p) => p.price,
                  exportValue: (p) => p.price.toStringAsFixed(2),
                  cell: (_, p) => Text(p.price.toStringAsFixed(2)),
                  width: 110,
                ),
                AdminColumn<WebStoreProduct>(
                  title: 'Stock',
                  sortable: true,
                  sortValue: (p) => p.stock ?? 0,
                  exportValue: (p) => '${p.stock ?? ''}',
                  cell: (_, p) => Text('${p.stock ?? '-'}'),
                  width: 110,
                ),
                AdminColumn<WebStoreProduct>(
                  title: 'Brand',
                  sortable: true,
                  sortValue: (p) => p.brand ?? '',
                  exportValue: (p) => p.brand ?? '',
                  cell: (_, p) => Text(p.brand ?? '-'),
                  width: 180,
                ),
              ],
            )
          : _ProductsList(items: items),
    );

    return Column(
      children: [
        Expanded(child: AppAnimation.fadeInUp(duration: const Duration(milliseconds: 420), child: box)),
      ],
    );
  }
}

class _ProductsList extends StatelessWidget {
  final List<WebStoreProduct> items;
  const _ProductsList({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: border),
      itemBuilder: (context, i) {
        final p = items[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.12),
            child: const Icon(Icons.inventory_2_rounded, color: AppColors.primaryOrange),
          ),
          title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('Price: ${p.price.toStringAsFixed(2)} • Stock: ${p.stock ?? '-'}'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () {},
        );
      },
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppColors.error.withValues(alpha: 0.08),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load products',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

