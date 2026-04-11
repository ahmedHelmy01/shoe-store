import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import '../view_model/products_state.dart';
import '../view_model/products_view_model.dart';
import '../widgets/products_table.dart';

class ProductsView extends ConsumerWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final state = ref.watch(productsVmProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Products', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
              ),
              IconButton(
                onPressed: () => ref.read(productsVmProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildBody(context, state, isDark, isWide)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductsState state, bool isDark, bool isWide) {
    return switch (state) {
      ProductsLoading() => const Center(child: CircularProgressIndicator()),
      ProductsError(:final message) => Center(child: Text(message)),
      ProductsData(:final items) => AppAnimation.fadeInUp(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
            ),
            child: isWide ? ProductsTable(items: items) : ListView.builder(itemCount: items.length, itemBuilder: (_, i) => ListTile(title: Text(items[i].name))),
          ),
        ),
    };
  }
}
