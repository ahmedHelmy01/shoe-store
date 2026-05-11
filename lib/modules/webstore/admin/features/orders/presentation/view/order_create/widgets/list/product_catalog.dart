import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/order_create_view_model.dart';
import 'product_item_card.dart';

class ProductCatalog extends StatefulWidget {
  final OrderCreateVm b;
  final ThemeData theme;
  final bool isDark;
  final Color border;
  final VoidCallback onSearchChanged;

  const ProductCatalog({
    super.key,
    required this.b,
    required this.theme,
    required this.isDark,
    required this.border,
    required this.onSearchChanged,
  });

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      if (!widget.b.isLoadingProducts && widget.b.hasMoreProducts) {
        widget.b.onFetchMoreProducts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.b;
    final selectedCount = b.selectedCatalogIds.length;
    final showSelection = selectedCount > 0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: AppTextField(
            controller: b.searchController,
            label: 'Search Products',
            hint: 'Search by name or SKU...',
            prefixIcon: const Icon(Icons.search_rounded),
            borderRadius: 14,
            onChanged: (_) => widget.onSearchChanged(),
          ),
        ),
        
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero).animate(anim),
              child: child,
            ),
          ),
          child: showSelection 
            ? _SelectionToolbar(b: b, count: selectedCount, theme: widget.theme)
            : const SizedBox.shrink(),
        ),

        Expanded(
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: b.filteredProducts.length + (b.hasMoreProducts ? 1 : 0),
            itemBuilder: (context, i) {
              if (i < b.filteredProducts.length) {
                return ProductItemCard(
                  p: b.filteredProducts[i],
                  b: b,
                  isDark: widget.isDark,
                  border: widget.border,
                  theme: widget.theme,
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _SelectionToolbar extends StatelessWidget {
  final OrderCreateVm b;
  final int count;
  final ThemeData theme;

  const _SelectionToolbar({
    required this.b,
    required this.count,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          Text(
            '$count Selected',
            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 20, color: theme.dividerColor),
          const SizedBox(width: 4),
          TextButton(
            onPressed: b.onClearSelection,
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: b.onCommitSelected,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
               'Add to Cart', 
               style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
