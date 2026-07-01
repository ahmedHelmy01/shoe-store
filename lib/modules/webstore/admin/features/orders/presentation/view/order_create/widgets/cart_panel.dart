import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_cart_line.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/order_create_view_model.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/widgets/order_qty_chip.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/widgets/order_summary_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class CartPanel extends StatelessWidget {
  final OrderCreateVm b;
  final ThemeData theme;
  final bool isDark;
  final Color border;

  const CartPanel({
    super.key,
    required this.b,
    required this.theme,
    required this.isDark,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCartHeader(context),
        const Divider(),
        if (b.cart.isEmpty)
          Expanded(child: Center(child: Text(AdminLocalizations.translate(context, 'cart is empty'))))
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: b.cart.length,
              itemBuilder: (context, i) => _buildCartLineItem(b.cart.values.elementAt(i)),
            ),
          ),
        _buildCartFooter(context),
      ],
    );
  }

  Widget _buildCartHeader(BuildContext context) {
    final count = b.cart.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AdminLocalizations.translate(context, 'order cart'),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, color: AppColors.primaryOrange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartLineItem(OrderCartLine line) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      elevation: 0,
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(line.name, maxLines: 2, style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => b.onRemoveLine(line.productId),
                ),
              ],
            ),
            Row(
              children: [
                Text(line.unitPrice.toStringAsFixed(2), style: theme.textTheme.bodySmall),
                const Spacer(),
                OrderQtyChip(
                  qty: line.qty,
                  onMinus: () => b.onDecrement(line),
                  onPlus: () => b.onIncrement(line),
                ),
                const SizedBox(width: 12),
                Text(
                  line.lineTotal.toStringAsFixed(2),
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          const Divider(),
          OrderSummaryRow(label: AdminLocalizations.translate(context, 'subtotal'), value: b.subtotal.toStringAsFixed(2), theme: theme),
          const SizedBox(height: 4),
          OrderSummaryRow(label: AdminLocalizations.translate(context, 'total'), value: b.total.toStringAsFixed(2), theme: theme, emphasize: true),
          const SizedBox(height: 12),
          AppButton(
            onPressed: b.onSubmit,
            isLoading: b.isSubmitting,
            height: 54,
            child: Text(AdminLocalizations.translate(context, 'confirm order creation'), style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
