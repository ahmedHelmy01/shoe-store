import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/data/fake_data.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_cart_line.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/order_create_view_model.dart';
import 'widgets/order_form_panel.dart';
import 'widgets/cart_panel.dart';
import 'widgets/list/product_catalog.dart';

class OrderCreateView extends ConsumerStatefulWidget {
  const OrderCreateView({super.key});

  @override
  ConsumerState<OrderCreateView> createState() => _OrderCreateViewState();
}

class _OrderCreateViewState extends ConsumerState<OrderCreateView> {
  final _searchCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  
  final Map<int, OrderCartLine> _cart = {};
  final Set<int> _selectedCatalogIds = {};
  int _discountPercent = 0;
  int? _customerId;
  String? _addressLine;
  String _payment = 'Cash';
  
  late List<WebStoreProduct> _allProducts;
  late List<WebStoreUser> _customers;

  @override
  void initState() {
    super.initState();
    _allProducts = FakeData.products();
    _customers = FakeData.users();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  List<WebStoreProduct> get _filteredProducts {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _allProducts;
    return _allProducts.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  double get _subtotal => _cart.values.fold(0, (sum, item) => sum + item.lineTotal);
  double get _discountAmount => _subtotal * (_discountPercent / 100);
  double get _total => _subtotal - _discountAmount;

  OrderCreateVm _getVm() {
    return OrderCreateVm(
      filteredProducts: _filteredProducts,
      cart: _cart,
      selectedCatalogIds: _selectedCatalogIds,
      searchController: _searchCtrl,
      notesController: _notesCtrl,
      discountPercent: _discountPercent,
      customerId: _customerId,
      addressLine: _addressLine,
      payment: _payment,
      customers: _customers,
      addressChoices: _customerId == null ? [] : ['Cairo, Abbasia', 'Giza, Pyramids', 'Alexandria, Corniche'],
      subtotal: _subtotal,
      discountAmount: _discountAmount,
      total: _total,
      productById: (id) => _allProducts.cast<WebStoreProduct?>().firstWhere((p) => p?.id == id, orElse: () => null),
      onCatalogSelect: (id, s) => setState(() => s ? _selectedCatalogIds.add(id) : _selectedCatalogIds.remove(id)),
      onCommitSelected: () {
        print('DEBUG: onCommitSelected called. Selected IDs: $_selectedCatalogIds');
        setState(() {
          for (final id in _selectedCatalogIds) {
            final p = _allProducts.firstWhere((p) => p.id == id);
            _addProduct(p);
          }
          _selectedCatalogIds.clear();
        });
      },
      onAddProduct: (p) {
        print('DEBUG: onAddProduct called for ${p.name}');
        setState(() => _addProduct(p));
      },
      onIncrement: (l) => setState(() => _cart[l.productId] = l.copyWith(qty: l.qty + 1)),
      onDecrement: (l) {
        if (l.qty > 1) {
          setState(() => _cart[l.productId] = l.copyWith(qty: l.qty - 1));
        }
      },
      onRemoveLine: (id) => setState(() => _cart.remove(id)),
      onCustomerChanged: (v) => setState(() {
        _customerId = v;
        _addressLine = null;
      }),
      onAddressChanged: (v) => setState(() => _addressLine = v),
      onPaymentChanged: (v) => setState(() => _payment = v),
      onDiscountChanged: (v) => setState(() => _discountPercent = v),
      onDropProduct: (id) {
         final p = _allProducts.firstWhere((p) => p.id == id);
         setState(() => _addProduct(p));
      },
      onClearSelection: () => setState(() => _selectedCatalogIds.clear()),
      onSubmit: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إنشاء الطلب بنجاح (Simulation)')),
        );
      },
    );
  }

  void _addProduct(WebStoreProduct p) {
    final pid = p.id;
    print('DEBUG: _addProduct called for ID: $pid');
    if (pid == null) return;
    if (_cart.containsKey(pid)) {
      final old = _cart[pid]!;
      _cart[pid] = old.copyWith(qty: old.qty + 1);
    } else {
      _cart[pid] = OrderCartLine(
        productId: pid,
        name: p.name,
        unitPrice: p.price,
        qty: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = _getVm();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);
    final cardBg = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04);
    final wide = MediaQuery.sizeOf(context).width >= 960;

    Widget panelBox({required Widget child, bool isExpanded = false}) {
      final box = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: cardBg,
          border: Border.all(color: border),
        ),
        child: child,
      );
      return isExpanded ? Expanded(child: box) : box;
    }

    Widget buildMainContent() {
      if (wide) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LEFT: PRODUCTS CATALOG
            Expanded(
              flex: 11,
              child: panelBox(
                child: Column(
                  children: [
                    OrderFormPanel(b: b, theme: theme),
                    const Divider(),
                    Expanded(
                      child: ProductCatalog(
                        b: b,
                        isDark: isDark,
                        theme: theme,
                        border: border,
                        onSearchChanged: () => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // RIGHT: CART
            Expanded(
              flex: 9,
              child: DragTarget<int>(
                onAcceptWithDetails: (d) {
                  final p = b.productById(d.data);
                  if (p != null) b.onAddProduct(p);
                },
                builder: (context, candidate, rejected) {
                  final hovering = candidate.isNotEmpty;
                  return panelBox(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: hovering ? Border.all(color: AppColors.primaryOrange, width: 2) : null,
                        color: hovering ? AppColors.primaryOrange.withValues(alpha: 0.05) : null,
                      ),
                      child: CartPanel(b: b, theme: theme, isDark: isDark, border: border),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              panelBox(
                child: Column(
                  children: [
                    OrderFormPanel(b: b, theme: theme),
                    const Divider(),
                    ProductCatalog(
                      b: b,
                      isDark: isDark,
                      theme: theme,
                      border: border,
                      onSearchChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DragTarget<int>(
                onAcceptWithDetails: (d) {
                  final p = b.productById(d.data);
                  if (p != null) b.onAddProduct(p);
                },
                builder: (context, candidate, rejected) {
                  final hovering = candidate.isNotEmpty;
                  return panelBox(
                    child: Container(
                      height: 500, // Fixed height for mobile cart preview
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: hovering ? Border.all(color: AppColors.primaryOrange, width: 2) : null,
                        color: hovering ? AppColors.primaryOrange.withValues(alpha: 0.05) : null,
                      ),
                      child: CartPanel(b: b, theme: theme, isDark: isDark, border: border),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }
    }

    return Padding(
      padding: wide ? const EdgeInsets.all(16) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (wide) ...[
            Text('طلب جديد', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
          ] else ...[
             Padding(
               padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
               child: Text('طلب جديد', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
             ),
          ],
          Expanded(
            child: AppAnimation.fadeInUp(
              duration: const Duration(milliseconds: 380),
              child: buildMainContent(),
            ),
          ),
        ],
      ),
    );
  }
}
