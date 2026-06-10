import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'widgets/catalog_header.dart';
import 'widgets/side_category_list.dart';
import '../products/product_grid_view.dart';

class CatalogView extends ConsumerStatefulWidget {
  const CatalogView({super.key});

  @override
  ConsumerState<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends ConsumerState<CatalogView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _productScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _productScrollController.addListener(_onScroll);
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _onScroll() {
    if (_productScrollController.position.pixels >=
        _productScrollController.position.maxScrollExtent - 200) {
      ref.read(catalogProductsProvider.notifier).getProducts();
    }
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(catalogProductsProvider.notifier).search(query);
      FocusScope.of(context).unfocus();
    }
  }

  void _handleClearSearch() {
    _searchController.clear();
    ref.read(catalogProductsProvider.notifier).search('');
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _productScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSearching = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Custom Header with Search & Clear
            CatalogHeader(
              controller: _searchController,
              onSearch: _handleSearch,
              onClear: _handleClearSearch,
            ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ Side Category Navigation
                  if (!isSearching) const SideCategoryList(),

                  // 📦 Products Display
                  Expanded(
                    child: ProductGridView(
                      scrollController: _productScrollController,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
