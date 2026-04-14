import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_cart_line.dart';

/// Data + callbacks for [OrderCreateView] (StatelessWidget).
class OrderCreateVm {
  final List<WebStoreProduct> filteredProducts;
  final Map<int, OrderCartLine> cart;
  final Set<int> selectedCatalogIds;
  final TextEditingController searchController;
  final TextEditingController notesController;
  final int discountPercent;
  final int? customerId;
  final String? addressLine;
  final String payment;
  final List<WebStoreUser> customers;
  final List<String> addressChoices;
  final double subtotal;
  final double discountAmount;
  final double total;
  final WebStoreProduct? Function(int productId) productById;

  final void Function(int productId, bool selected) onCatalogSelect;
  final VoidCallback onCommitSelected;
  final void Function(WebStoreProduct) onAddProduct;
  final void Function(OrderCartLine) onIncrement;
  final void Function(OrderCartLine) onDecrement;
  final void Function(int productId) onRemoveLine;
  final void Function(int?) onCustomerChanged;
  final void Function(String?) onAddressChanged;
  final void Function(String) onPaymentChanged;
  final void Function(int) onDiscountChanged;
  final void Function(int productId) onDropProduct;
  final VoidCallback onClearSelection;
  final VoidCallback onSubmit;

  const OrderCreateVm({
    required this.filteredProducts,
    required this.cart,
    required this.selectedCatalogIds,
    required this.searchController,
    required this.notesController,
    required this.discountPercent,
    required this.customerId,
    required this.addressLine,
    required this.payment,
    required this.customers,
    required this.addressChoices,
    required this.subtotal,
    required this.discountAmount,
    required this.total,
    required this.productById,
    required this.onCatalogSelect,
    required this.onCommitSelected,
    required this.onAddProduct,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemoveLine,
    required this.onCustomerChanged,
    required this.onAddressChanged,
    required this.onPaymentChanged,
    required this.onDiscountChanged,
    required this.onDropProduct,
    required this.onClearSelection,
    required this.onSubmit,
  });
}
