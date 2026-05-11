import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/features/users/data/models/user_row.dart';
import 'package:erp/modules/webstore/admin/features/catalog/products/data/models/product_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_cart_line.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/models/address_row.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';

/// Data + callbacks for [OrderCreateView] (StatelessWidget).
class OrderCreateVm {
  final List<ProductRow> filteredProducts;
  final Map<int, OrderCartLine> cart;
  final Set<int> selectedCatalogIds;
  final TextEditingController searchController;
  final TextEditingController notesController;
  final int discountPercent;
  final int? customerId;
  final int? addressId;
  final int? paymentMethodId;
  final List<UserRow> customers;
  final List<AddressRow> addressChoices;
  final List<PaymentMethodRow> paymentMethods;
  final double subtotal;
  final double discountAmount;
  final double total;
  final ProductRow? Function(int productId) productById;

  final void Function(int productId, bool selected) onCatalogSelect;
  final VoidCallback onCommitSelected;
  final void Function(ProductRow) onAddProduct;
  final void Function(OrderCartLine) onIncrement;
  final void Function(OrderCartLine) onDecrement;
  final void Function(int productId) onRemoveLine;
  final void Function(int?) onCustomerChanged;
  final void Function(int?) onAddressChanged;
  final void Function(int?) onPaymentChanged;
  final void Function(int) onDiscountChanged;
  final void Function(int productId) onDropProduct;
  final VoidCallback onClearSelection;
  final VoidCallback onSubmit;

  final bool isLoadingProducts;
  final bool isSubmitting;
  final VoidCallback onFetchMoreProducts;
  final bool hasMoreProducts;

  const OrderCreateVm({
    required this.filteredProducts,
    required this.cart,
    required this.selectedCatalogIds,
    required this.searchController,
    required this.notesController,
    required this.discountPercent,
    required this.customerId,
    required this.addressId,
    required this.paymentMethodId,
    required this.customers,
    required this.addressChoices,
    required this.paymentMethods,
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
    this.isLoadingProducts = false,
    this.isSubmitting = false,
    required this.onFetchMoreProducts,
    this.hasMoreProducts = false,
  });
}
