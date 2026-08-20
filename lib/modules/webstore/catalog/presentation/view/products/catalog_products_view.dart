import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/modules/webstore/catalog/data/models/manufacturer_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/tag_model.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/product_details/product_details_view.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/products/widgets/catalog_products_body.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/products/widgets/catalog_products_filter_action.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/products/widgets/catalog_products_filter_drawer.dart';
import 'package:erp/modules/webstore/catalog/presentation/view_model/catalog_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogProductsView extends ConsumerStatefulWidget {
  final String? initialPreset;
  final int? initialCategoryId;
  final int? initialManufacturerId;
  final String? initialScreenTitle;

  const CatalogProductsView({
    super.key,
    this.initialPreset,
    this.initialCategoryId,
    this.initialManufacturerId,
    this.initialScreenTitle,
  });

  @override
  ConsumerState<CatalogProductsView> createState() =>
      _CatalogProductsViewState();
}

class _CatalogProductsViewState extends ConsumerState<CatalogProductsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  int? _selectedCategoryId;
  int? _selectedManufacturerId;
  int? _selectedTagId;
  String _sortBy = 'created_at';
  String _sortDir = 'desc';
  bool _onlyInStock = false;
  double _priceFrom = 0;
  double _priceTo = 1000;
  bool _priceTouched = false;
  bool _filtersApplied = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
    _selectedManufacturerId = widget.initialManufacturerId;
    _scrollController.addListener(_onScroll);
    _applyPreset(widget.initialPreset);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_filtersApplied) {
      _filtersApplied = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _applyFiltersToApi());
    }
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 220) {
      _isLoadingMore = true;
      ref.read(presetProductsProvider.notifier).getProducts().then((_) {
        if (mounted) setState(() => _isLoadingMore = false);
      }).catchError((_) {
        if (mounted) setState(() => _isLoadingMore = false);
      });
    }
  }

  void _applyPreset(String? preset) {
    switch (preset) {
      case 'best_seller':
        _sortBy = 'sale_price';
        _sortDir = 'desc';
        break;
      case 'offers':
      case 'store_offers':
        _sortBy = 'sale_price';
        _sortDir = 'desc';
        break;
      case 'latest':
      case 'newest':
        _sortBy = 'created_at';
        _sortDir = 'desc';
        break;
      default:
        _sortBy = 'created_at';
        _sortDir = 'desc';
    }
  }

  String _screenTitle(BuildContext context) {
    final custom = widget.initialScreenTitle?.trim();
    if (custom != null && custom.isNotEmpty) {
      return custom;
    }
    final keys = LocaleKeys.webstore;
    switch (widget.initialPreset) {
      case 'offers':
      case 'store_offers':
        return keys.home.store_offers.tr(context: context);
      case 'exclusive':
        return keys.home.feature_exclusive_offers.tr(context: context);
      case 'best_seller':
        return keys.home.feature_best_sellers.tr(context: context);
      case 'shop_now':
        return keys.home.shop_now.tr(context: context);
      case 'latest':
      case 'newest':
        return keys.home.feature_new_arrivals.tr(context: context);
      default:
        return keys.catalog.all_products.tr(context: context);
    }
  }

  void _applyFiltersToApi() {
    ref
        .read(presetProductsProvider.notifier)
        .applyApiFilters(
          categoryId: _selectedCategoryId,
          manufacturerId: _selectedManufacturerId,
          tagId: _selectedTagId,
          priceFrom: _priceTouched ? _priceFrom : null,
          priceTo: _priceTouched ? _priceTo : null,
          isAvailable: _onlyInStock ? true : null,
          sortBy: _sortBy,
          sortDir: _sortDir,
        );
  }

  int _activeFiltersCount() {
    var count = 0;
    if (_selectedCategoryId != null) count++;
    if (_selectedManufacturerId != null) count++;
    if (_selectedTagId != null) count++;
    if (_onlyInStock) count++;
    if (_priceTouched) count++;
    if (_sortBy != 'created_at' || _sortDir != 'desc') count++;
    return count;
  }

  void _resetFilters() {
    setState(() {
      _selectedCategoryId = null;
      _selectedManufacturerId = null;
      _selectedTagId = null;
      _onlyInStock = false;
      _priceFrom = 0;
      _priceTo = 1000;
      _priceTouched = false;
      _applyPreset(widget.initialPreset);
    });
    _applyFiltersToApi();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final productsState = ref.watch(presetProductsProvider);
    final categoriesState = ref.watch(catalogCategoriesProvider);
    final manufacturers = ref
        .watch(catalogManufacturersProvider)
        .maybeWhen(data: (list) => list, orElse: () => <ManufacturerModel>[]);
    final tags = ref
        .watch(catalogTagsProvider)
        .maybeWhen(data: (list) => list, orElse: () => <TagModel>[]);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        titleText: _screenTitle(context),
        backgroundColor:
            appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        foregroundColor:
            appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
        showBackButton: true,
        actions: [
          CatalogProductsFilterAction(
            activeFiltersCount: _activeFiltersCount(),
            onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: CatalogProductsFilterDrawer(
        categories: categoriesState.items,
        manufacturers: manufacturers,
        tags: tags,
        selectedCategoryId: _selectedCategoryId,
        selectedManufacturerId: _selectedManufacturerId,
        selectedTagId: _selectedTagId,
        sortBy: _sortBy,
        sortDir: _sortDir,
        onlyInStock: _onlyInStock,
        priceValues: RangeValues(_priceFrom, _priceTo),
        onCategoryChanged: (value) =>
            setState(() => _selectedCategoryId = value),
        onManufacturerChanged: (value) =>
            setState(() => _selectedManufacturerId = value),
        onTagChanged: (value) => setState(() => _selectedTagId = value),
        onSortByChanged: (value) => setState(() => _sortBy = value),
        onSortDirChanged: (value) => setState(() => _sortDir = value),
        onPriceChanged: (value) {
          setState(() {
            _priceFrom = value.start;
            _priceTo = value.end;
            _priceTouched = true;
          });
        },
        onOnlyInStockChanged: (value) => setState(() => _onlyInStock = value),
        onReset: _resetFilters,
        onApply: () {
          _applyFiltersToApi();
          Navigator.of(context).pop();
        },
      ),
      body: CatalogProductsBody(
        productsState: productsState,
        products: productsState.items,
        scrollController: _scrollController,
        onProductTap: (product) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsView(product: product),
            ),
          );
        },
        onRetry: () {
          ref.read(presetProductsProvider.notifier).getProducts(isRefresh: true);
        },
      ),
    );
  }
}
