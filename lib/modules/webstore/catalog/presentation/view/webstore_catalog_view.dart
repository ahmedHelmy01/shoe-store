/// WebStore Catalog View (Vertical Slices)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/config/app_flavor.dart';
import 'package:erp/core/common_widget/app_pagination/app_paginated_list.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_card.dart';

class WebStoreCatalogView extends ConsumerStatefulWidget {
  const WebStoreCatalogView({super.key});

  @override
  ConsumerState<WebStoreCatalogView> createState() => _WebStoreCatalogViewState();
}

class _WebStoreCatalogViewState extends ConsumerState<WebStoreCatalogView> {
  int? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(catalogProductsProvider);
    final categoriesAsync = ref.watch(catalogCategoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(FlavorConfig.appName),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'بحث عن منتجات...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onSubmitted: (value) {
                ref.read(catalogProductsProvider.notifier).search(value);
              },
            ),
          ),

          // 🏷️ Categories Ribbon
          SizedBox(
            height: 48,
            child: categoriesAsync.when(
              data: (categories) => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                separatorBuilder: (_, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final category = isAll ? null : categories[index - 1];
                  final isSelected = isAll 
                      ? _selectedCategoryId == null 
                      : _selectedCategoryId == category?.id;

                  return ChoiceChip(
                    label: Text(isAll ? 'الكل' : category!.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategoryId = category?.id);
                        ref.read(catalogProductsProvider.notifier).filterByCategory(category?.id);
                      }
                    },
                  );
                },
              ),
              loading: () => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: AppShimmer.box(width: 80, height: 32, borderRadius: 20),
                ),
              ),
              error: (err, _) => const SizedBox.shrink(),
            ),
          ),

          const SizedBox(height: 16),

          // 📦 Products Grid (Paginated)
          Expanded(
            child: AppPaginatedList<WebStoreProduct>(
              items: productsState.items,
              isLoading: productsState.isLoading,
              isLoadingMore: productsState.isLoadingMore,
              hasMore: productsState.hasMore,
              errorMessage: productsState.errorMessage,
              onLoadMore: () {
                ref.read(catalogProductsProvider.notifier).getProducts();
              },
              onRefresh: () async {
                ref.read(catalogProductsProvider.notifier).getProducts(isRefresh: true);
              },
              onRetry: () {
                ref.read(catalogProductsProvider.notifier).getProducts(isRefresh: true);
              },
              loadingWidget: _buildGridShimmer(),
              itemBuilder: (context, item, index) {
                return ProductCard(
                  product: item,
                  onTap: () {
                    // Navigate to details
                  },
                  onAddToCart: () {
                    // Add to cart logic
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (_, index) => AppShimmer.productCard(),
    );
  }
}
