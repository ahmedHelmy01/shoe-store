import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/presentation/view/products_view.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/presentation/view/categories_view.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/presentation/view/companies_view.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/presentation/view/filters_view.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class CatalogView extends ConsumerStatefulWidget {
  const CatalogView({super.key});

  @override
  ConsumerState<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends ConsumerState<CatalogView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5),
            unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            dividerColor: Colors.transparent,
            indicatorColor: theme.primaryColor,
            tabs: [
              Tab(text: AdminLocalizations.translate(context, 'products'), icon: const Icon(Icons.inventory_2_rounded, size: 20)),
              Tab(text: AdminLocalizations.translate(context, 'categories'), icon: const Icon(Icons.account_tree_rounded, size: 20)),
              Tab(text: AdminLocalizations.translate(context, 'companies'), icon: const Icon(Icons.apartment_rounded, size: 20)),
              Tab(text: AdminLocalizations.translate(context, 'tags'), icon: const Icon(Icons.tune_rounded, size: 20)),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              ProductsView(),
              CategoriesView(),
              CompaniesView(),
              FiltersView(),
            ],
          ),
        ),
      ],
    );
  }
}
