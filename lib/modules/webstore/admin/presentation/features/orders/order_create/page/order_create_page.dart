import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/presentation/models/admin_fake_data.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/admin/presentation/features/orders/order_create/models/order_cart_line.dart';
import 'package:erp/modules/webstore/admin/presentation/features/orders/order_create/order_create_binding.dart';
import 'package:erp/modules/webstore/admin/presentation/features/orders/order_create/view/order_create_view.dart';

/// Stateful shell: catalog, cart, customer — delegates UI to [OrderCreateView].
class OrderCreatePage extends StatefulWidget {
  const OrderCreatePage({super.key});

  @override
  State<OrderCreatePage> createState() => _OrderCreatePageState();
}

class _OrderCreatePageState extends State<OrderCreatePage> {
  late final List<WebStoreProduct> _catalog;
  late final List<WebStoreUser> _customers;
  final Map<int, OrderCartLine> _cart = {};
  final Set<int> _selectedCatalogIds = {};
  final TextEditingController _search = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  String _query = '';
  int _discountPercent = 0;
  int? _customerId;
  String? _addressLine;
  String _payment = 'Cash';

  @override
  void initState() {
    super.initState();
    _catalog = AdminFakeData.products(count: 48, seed: 41);
    _customers = AdminFakeData.users(count: 40, seed: 29);
    _search.addListener(() {
      setState(() => _query = _search.text.trim().toLowerCase());
    });
  }

  List<String> _addressesForUser(int userId) {
    const districts = [
      'مدينة نصر',
      'المعادي',
      'الزهراء',
      'التجمع الخامس',
      '6 أكتوبر',
      'الإسكندرية سموحة',
    ];
    const streets = [
      'شارع الحجاز',
      'شارع النصر',
      'طريق السويس',
      'محور المشير',
      'شارع الجامعة',
    ];
    return List.generate(4, (i) {
      final d = districts[(userId + i) % districts.length];
      final s = streets[(userId + 2 * i) % streets.length];
      return '$d، $s، مبنى ${(userId % 9) + 1} — شقة ${10 + i + userId % 5}';
    });
  }

  List<String> get _addressChoices =>
      _customerId == null ? const [] : _addressesForUser(_customerId!);

  WebStoreProduct? _productById(int productId) {
    for (final p in _catalog) {
      if (p.id == productId) return p;
    }
    return null;
  }

  @override
  void dispose() {
    _search.dispose();
    _notes.dispose();
    super.dispose();
  }

  List<WebStoreProduct> get _filtered {
    if (_query.isEmpty) return _catalog;
    return _catalog
        .where((p) =>
            p.name.toLowerCase().contains(_query) ||
            (p.brand?.toLowerCase().contains(_query) ?? false))
        .toList();
  }

  double get _subtotal =>
      _cart.values.fold<double>(0, (s, l) => s + l.lineTotal);

  double get _discountAmount => _subtotal * (_discountPercent / 100);

  double get _total => _subtotal - _discountAmount;

  void _addProduct(WebStoreProduct p) {
    final id = p.id;
    if (id == null) return;
    setState(() {
      final existing = _cart[id];
      if (existing != null) {
        existing.qty += 1;
      } else {
        _cart[id] = OrderCartLine(
          productId: id,
          name: p.name,
          unitPrice: p.price,
        );
      }
    });
  }

  void _commitCartAdds() {
    if (_selectedCatalogIds.isEmpty) return;
    setState(() {
      for (final id in _selectedCatalogIds.toList()) {
        WebStoreProduct? prod;
        for (final c in _catalog) {
          if (c.id == id) {
            prod = c;
            break;
          }
        }
        if (prod == null) continue;
        final pid = prod.id;
        if (pid == null) continue;
        final existing = _cart[pid];
        if (existing != null) {
          existing.qty += 1;
        } else {
          _cart[pid] = OrderCartLine(
            productId: pid,
            name: prod.name,
            unitPrice: prod.price,
          );
        }
      }
      _selectedCatalogIds.clear();
    });
  }

  void _increment(OrderCartLine line) {
    setState(() => line.qty += 1);
  }

  void _decrement(OrderCartLine line) {
    setState(() {
      if (line.qty > 1) {
        line.qty -= 1;
      } else {
        _cart.remove(line.productId);
      }
    });
  }

  void _removeLine(int productId) {
    setState(() => _cart.remove(productId));
  }

  void _catalogSelect(int productId, bool selected) {
    setState(() {
      if (selected) {
        _selectedCatalogIds.add(productId);
      } else {
        _selectedCatalogIds.remove(productId);
      }
    });
  }

  void _onCustomerChanged(int? id) {
    setState(() {
      _customerId = id;
      final list = id == null ? <String>[] : _addressesForUser(id);
      _addressLine = list.isEmpty ? null : list.first;
    });
  }

  void _submit() {
    if (_customerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر العميل من القائمة')),
      );
      return;
    }
    if (_addressLine == null || _addressLine!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر عنوان التوصيل')),
      );
      return;
    }
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أضف منتجات إلى السلة أولاً')),
      );
      return;
    }
    String customerName = 'عميل $_customerId';
    for (final u in _customers) {
      if (u.id == _customerId) {
        customerName = u.name;
        break;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إنشاء الطلب (تجريبي): $customerName • ${_cart.length} صنف • $_payment • ${_total.toStringAsFixed(2)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrderCreateView(
      b: OrderCreateBinding(
        filteredProducts: _filtered,
        cart: _cart,
        selectedCatalogIds: _selectedCatalogIds,
        searchController: _search,
        notesController: _notes,
        discountPercent: _discountPercent,
        customerId: _customerId,
        addressLine: _addressLine,
        payment: _payment,
        customers: _customers,
        addressChoices: _addressChoices,
        subtotal: _subtotal,
        discountAmount: _discountAmount,
        total: _total,
        productById: _productById,
        onCatalogSelect: _catalogSelect,
        onCommitSelected: _commitCartAdds,
        onAddProduct: _addProduct,
        onIncrement: _increment,
        onDecrement: _decrement,
        onRemoveLine: _removeLine,
        onCustomerChanged: _onCustomerChanged,
        onAddressChanged: (v) => setState(() => _addressLine = v),
        onPaymentChanged: (v) => setState(() => _payment = v),
        onDiscountChanged: (v) => setState(() => _discountPercent = v),
        onDropProduct: (productId) {
          final p = _productById(productId);
          if (p != null) _addProduct(p);
        },
        onSubmit: _submit,
      ),
    );
  }
}
