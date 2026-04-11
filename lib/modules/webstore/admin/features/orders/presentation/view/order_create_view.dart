import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import '../view_model/order_create_view_model.dart';
import '../widgets/order_qty_chip.dart';
import '../widgets/order_summary_row.dart';

const _kDiscountOptions = [0, 5, 10, 15, 20];
const _kPayments = ['Cash', 'Card', 'InstaPay'];

class OrderCreateView extends StatelessWidget {
  final OrderCreateVm b;
  const OrderCreateView({super.key, required this.b});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);
    final cardBg = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04);
    final wide = MediaQuery.sizeOf(context).width >= 960;

    Widget panelDecoration({required Widget child}) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: cardBg,
          border: Border.all(color: border),
        ),
        child: child,
      );
    }

    final productPanel = panelDecoration(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'بيانات الطلب',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                AppDropdown<int>(
                  label: 'العميل',
                  hint: 'اختر العميل',
                  value: b.customerId,
                  borderRadius: 12,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  items: b.customers
                      .map((u) => DropdownMenuItem(
                            value: u.id,
                            child: Text(
                              '${u.name} — ${u.mobile ?? u.email ?? '—'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  onChanged: b.onCustomerChanged,
                ),
                const SizedBox(height: 10),
                AppDropdown<String>(
                  label: 'عنوان التوصيل',
                  hint: 'اختر العنوان بعد اختيار العميل',
                  enabled: b.customerId != null,
                  value: b.addressLine != null && b.addressChoices.contains(b.addressLine) ? b.addressLine : null,
                  borderRadius: 12,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  items: b.addressChoices
                      .map((a) => DropdownMenuItem(
                            value: a,
                            child: Text(a, maxLines: 2, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: b.customerId == null ? null : b.onAddressChanged,
                ),
                const SizedBox(height: 10),
                AppDropdown<String>(
                  label: 'طريقة الدفع',
                  value: b.payment,
                  borderRadius: 12,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  items: _kPayments.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) {
                    if (v != null) b.onPaymentChanged(v);
                  },
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: b.notesController,
                  label: 'ملاحظات الطلب (اختياري)',
                  hint: 'تعليمات التسليم، وقت الاتصال، إلخ…',
                  maxLines: 4,
                  borderRadius: 12,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: b.searchController,
                  label: 'البحث عن المنتجات',
                  hint: 'ابحث بالاسم أو الماركة…',
                  prefixIcon: const Icon(Icons.search_rounded),
                  borderRadius: 14,
                ),
                const SizedBox(height: 8),
                Text(
                  'اسحب المنتج: اضغط مطولاً على البطاقة ثم حرّكها إلى منطقة السلة.',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),
          if (b.selectedCatalogIds.isNotEmpty)
            Material(
              color: AppColors.primaryOrange.withValues(alpha: 0.12),
              child: InkWell(
                onTap: b.onCommitSelected,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add_shopping_cart_rounded, color: AppColors.primaryOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'إضافة المختار (${b.selectedCatalogIds.length}) للسلة',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.primaryOrange,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
              itemCount: b.filteredProducts.length,
              itemBuilder: (context, i) {
                final p = b.filteredProducts[i];
                final pid = p.id;
                if (pid == null) return const SizedBox.shrink();
                final inCart = b.cart.containsKey(pid);
                final selected = b.selectedCatalogIds.contains(pid);
                final productCard = Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  elevation: 0,
                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: border),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Checkbox(value: selected, onChanged: (v) => b.onCatalogSelect(pid, v == true)),
                    title: Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${p.price.toStringAsFixed(2)} • مخزون ${p.stock}', style: theme.textTheme.bodySmall),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'سحب للسلة (ضغط مطوّل)',
                          child: Icon(Icons.drag_indicator_rounded, color: theme.hintColor, size: 22),
                        ),
                        if (inCart)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(Icons.check_circle_rounded, size: 20, color: Colors.green.shade600),
                          ),
                        IconButton.filledTonal(
                          tooltip: 'إضافة',
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
                    elevation: 10,
                    shadowColor: Colors.black54,
                    borderRadius: BorderRadius.circular(14),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: ListTile(
                        tileColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        leading: Icon(Icons.inventory_2_rounded, color: AppColors.primaryOrange),
                        title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(p.price.toStringAsFixed(2)),
                      ),
                    ),
                  ),
                  childWhenDragging: Opacity(opacity: 0.42, child: productCard),
                  child: productCard,
                );
              },
            ),
          ),
        ],
      ),
    );

    final cartLines = b.cart.values.toList();
    final cartPanel = panelDecoration(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text('سلة الطلب', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${cartLines.length}',
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, color: AppColors.primaryOrange),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: DragTarget<int>(
                onAcceptWithDetails: (details) {
                  final productId = details.data;
                  final p = b.productById(productId);
                  if (p != null) b.onAddProduct(p);
                },
                builder: (context, candidate, rejected) {
                  final hovering = candidate.isNotEmpty;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        width: 2,
                        color: hovering ? AppColors.primaryOrange : border.withValues(alpha: 0.5),
                      ),
                      color: hovering ? AppColors.primaryOrange.withValues(alpha: 0.07) : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.02),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: cartLines.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.touch_app_rounded, size: 40, color: theme.hintColor),
                                    const SizedBox(height: 12),
                                    Text(
                                      hovering ? 'أفلت هنا لإضافة المنتج' : 'أسقط المنتجات هنا\nأو استخدم + وإضافة المختار',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor, height: 1.35),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                              itemCount: cartLines.length,
                              itemBuilder: (context, i) {
                                final line = cartLines[i];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                line.name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            IconButton(
                                              tooltip: 'حذف',
                                              icon: const Icon(Icons.close_rounded, size: 20),
                                              onPressed: () => b.onRemoveLine(line.productId),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
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
                              },
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text('الخصم', style: theme.textTheme.bodyMedium),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppDropdown<int>(
                        label: null,
                        value: b.discountPercent,
                        borderRadius: 12,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        items: _kDiscountOptions
                            .map((d) => DropdownMenuItem(value: d, child: Text(d == 0 ? 'بدون خصم' : '$d%')))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) b.onDiscountChanged(v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OrderSummaryRow(label: 'المجموع الفرعي', value: b.subtotal.toStringAsFixed(2), theme: theme),
                if (b.discountPercent > 0)
                  OrderSummaryRow(
                    label: 'خصم (${b.discountPercent}%)',
                    value: '-${b.discountAmount.toStringAsFixed(2)}',
                    theme: theme,
                    muted: true,
                  ),
                const Divider(height: 20),
                OrderSummaryRow(label: 'الإجمالي', value: b.total.toStringAsFixed(2), theme: theme, emphasize: true),
                const SizedBox(height: 12),
                AppButton(
                  onPressed: b.onSubmit,
                  height: 64,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 28),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded, size: 26, color: Colors.white),
                      SizedBox(width: 12),
                      Text('تأكيد إنشاء الطلب', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final body = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 11, child: productPanel),
              const SizedBox(width: 16),
              Expanded(flex: 9, child: cartPanel),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 5, child: productPanel),
              const SizedBox(height: 12),
              Expanded(flex: 5, child: cartPanel),
            ],
          );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('طلب جديد', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(
            'اكتب بيانات العميل والعنوان، ثم أضف المنتجات (بحث، تحديد، سحب وإفلات، أو +). طبّق الخصم ثم أكّد الطلب.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: AppAnimation.fadeInUp(duration: const Duration(milliseconds: 380), child: body),
          ),
        ],
      ),
    );
  }
}
