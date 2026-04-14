import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/order_create_view_model.dart';

class ProductItemCard extends StatelessWidget {
  final WebStoreProduct p;
  final OrderCreateVm b;
  final bool isDark;
  final Color border;
  final ThemeData theme;

  const ProductItemCard({
    super.key,
    required this.p,
    required this.b,
    required this.isDark,
    required this.border,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final pid = p.id;
    if (pid == null) return const SizedBox.shrink();
    final inCart = b.cart.containsKey(pid);
    final selected = b.selectedCatalogIds.contains(pid);

    final card = Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 0,
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: selected,
          onChanged: (v) => b.onCatalogSelect(pid, v == true),
        ),
        title: Text(
          p.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${p.price.toStringAsFixed(2)} • مخزون ${p.stock}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (inCart)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green.withValues(alpha: 0.8),
                  size: 20,
                ),
              ),
            Tooltip(
              message: 'سحب لإضافة الطلب',
              child: Icon(
                Icons.drag_indicator_rounded,
                color: theme.hintColor.withValues(alpha: 0.5),
                size: 22,
              ),
            ),
            const SizedBox(width: 4),
            IconButton.filledTonal(
              onPressed: () => b.onAddProduct(p),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ),
    );

    return LongPressDraggable<int>(
      data: pid,
      feedback: Material(
        elevation: 12,
        shadowColor: AppColors.primaryOrange.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 280,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrange.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Text(
                p.price.toStringAsFixed(2),
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: card,
    );
  }
}
