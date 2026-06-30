import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/features/users/presentation/view_model/users_view_model.dart';
import 'package:erp/modules/webstore/admin/features/users/data/models/user_row.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/presentation/view_model/products_view_model.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/models/address_row.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/presentation/view_model/payment_methods_view_model.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_cart_line.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/order_create_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import '../../../../addresses/presentation/view_model/addresses_view_model.dart';
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
  int? _addressId;
  int? _paymentMethodId;
  
  List<AddressRow> _customerAddresses = [];
  bool _isLoadingAddresses = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(usersVmProvider.notifier).fetch();
      ref.read(paymentMethodsVmProvider.notifier).fetch();
      ref.read(productsVmProvider.notifier).fetch();
    });

    _searchCtrl.addListener(() {
      ref.read(productsVmProvider.notifier).fetch(search: _searchCtrl.text);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomerAddresses(int customerId) async {
    setState(() {
      _isLoadingAddresses = true;
      _customerAddresses = [];
      _addressId = null;
    });

    final repo = ref.read(addressesRepositoryProvider);
    final result = await repo.getAddresses(customerId: customerId);

    if (mounted) {
      result.when(
        success: (paged) {
          print('DEBUG: Fetched ${paged.items.length} addresses for customer $customerId');
          setState(() {
            _customerAddresses = paged.items;
            _isLoadingAddresses = false;
          });
        },
        failure: (e) {
          print('DEBUG: Failed to fetch addresses: ${e.message}');
          setState(() => _isLoadingAddresses = false);
        },
      );
    }
  }

  double get _subtotal => _cart.values.fold(0, (sum, item) => sum + item.lineTotal);
  double get _discountAmount => _subtotal * (_discountPercent / 100);
  double get _total => _subtotal - _discountAmount;

  bool _isSubmitting = false;

  void _submitOrder(OrderCreateVm b) async {
    if (b.customerId == null || b.addressId == null || b.paymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AdminLocalizations.translate(context, 'please complete order information (customer, address, payment)'))),
      );
      return;
    }

    if (b.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AdminLocalizations.translate(context, 'your cart is empty'))),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final repo = ref.read(ordersRepositoryProvider);
    
    // Prepare items for API
    final items = b.cart.values.map((l) => {
      'product_id': l.productId,
      'quantity': l.qty,
    }).toList();

    final data = {
      'customer_id': b.customerId,
      'address_id': b.addressId,
      'payment_method_id': b.paymentMethodId,
      'notes': _notesCtrl.text.trim(),
      'items': items,
      'discount': b.discountPercent,
    };

    final result = await repo.saveOrder(data);

    if (mounted) {
      setState(() => _isSubmitting = false);
      
      result.when(
        success: (order) {
          AppStatusDialog.show(
            context,
            status: AppDialogStatus.success,
            title: AdminLocalizations.translate(context, 'success'),
            message: '${AdminLocalizations.translate(context, 'order #')}${order.id} ${AdminLocalizations.translate(context, 'created successfully')}',
          );
          // Clear cart and state after success
          setState(() {
            _cart.clear();
            _customerId = null;
            _addressId = null;
            _customerAddresses = [];
            _notesCtrl.clear();
          });
        },
        failure: (e) {
          AppStatusDialog.show(
            context,
            status: AppDialogStatus.error,
            title: AdminLocalizations.translate(context, 'failed'),
            message: e.message,
          );
        },
      );
    }
  }

  OrderCreateVm _getVm() {
    final usersState = ref.watch(usersVmProvider);
    final paymentMethodsState = ref.watch(paymentMethodsVmProvider);
    final productsState = ref.watch(productsVmProvider);

    List<UserRow> customers = [];
    if (usersState is AdminCrudData<UserRow>) customers = usersState.items;

    List<PaymentMethodRow> paymentMethods = [];
    if (paymentMethodsState is AdminCrudData<PaymentMethodRow>) paymentMethods = paymentMethodsState.items;

    List<ProductRow> products = [];
    bool hasMore = false;
    bool loadingProducts = false;
    if (productsState is AdminCrudData<ProductRow>) {
      products = productsState.items;
      hasMore = productsState.hasMore;
    } else if (productsState is AdminCrudLoading) {
      loadingProducts = true;
    }

    return OrderCreateVm(
      filteredProducts: products,
      cart: _cart,
      selectedCatalogIds: _selectedCatalogIds,
      searchController: _searchCtrl,
      notesController: _notesCtrl,
      discountPercent: _discountPercent,
      customerId: _customerId,
      addressId: _addressId,
      paymentMethodId: _paymentMethodId,
      customers: customers,
      addressChoices: _customerAddresses,
      paymentMethods: paymentMethods,
      subtotal: _subtotal,
      discountAmount: _discountAmount,
      total: _total,
      productById: (id) => products.cast<ProductRow?>().firstWhere((p) => p?.id == id, orElse: () => null),
      onCatalogSelect: (id, s) => setState(() => s ? _selectedCatalogIds.add(id) : _selectedCatalogIds.remove(id)),
      onCommitSelected: () {
        setState(() {
          for (final id in _selectedCatalogIds) {
            final p = products.firstWhere((p) => p.id == id);
            _addProduct(p);
          }
          _selectedCatalogIds.clear();
        });
      },
      onAddProduct: (p) => setState(() => _addProduct(p)),
      onIncrement: (l) => setState(() => _cart[l.productId] = l.copyWith(qty: l.qty + 1)),
      onDecrement: (l) {
        if (l.qty > 1) {
          setState(() => _cart[l.productId] = l.copyWith(qty: l.qty - 1));
        }
      },
      onRemoveLine: (id) => setState(() => _cart.remove(id)),
      onCustomerChanged: (v) {
        setState(() {
          _customerId = v;
          _addressId = null;
        });
        if (v != null) _fetchCustomerAddresses(v);
      },
      onAddressChanged: (v) => setState(() => _addressId = v),
      onPaymentChanged: (v) => setState(() => _paymentMethodId = v),
      onDiscountChanged: (v) => setState(() => _discountPercent = v),
      onDropProduct: (id) {
         final p = products.firstWhere((p) => p.id == id);
         setState(() => _addProduct(p));
      },
      onClearSelection: () => setState(() => _selectedCatalogIds.clear()),
      onSubmit: () => _submitOrder(_getVm()),
      isLoadingProducts: loadingProducts,
      isSubmitting: _isSubmitting,
      hasMoreProducts: hasMore,
      onFetchMoreProducts: () {
        ref.read(productsVmProvider.notifier).fetchMore();
      },
    );
  }

  void _addProduct(ProductRow p) {
    final pid = p.id;
    final price = double.tryParse(p.salePrice ?? '0') ?? 0;
    if (_cart.containsKey(pid)) {
      final old = _cart[pid]!;
      _cart[pid] = old.copyWith(qty: old.qty + 1);
    } else {
      _cart[pid] = OrderCartLine(
        productId: pid,
        name: p.name,
        unitPrice: price,
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
            Text(AdminLocalizations.translate(context, 'new order'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
          ] else ...[
             Padding(
               padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
               child: Text('New Order', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
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
