import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_detail.dart';

class OrderDetailsDialog extends StatelessWidget {
  final OrderDetail order;

  const OrderDetailsDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final df = DateFormat('yyyy-MM-dd HH:mm');

    return AdminDetailsDialog(
      title: '${AdminLocalizations.translate(context, 'order')} #${order.id}',
      id: order.orderNumber,
      icon: Icons.receipt_long_rounded,
      maxWidth: 720,
      children: [
        // Status badges row
        Row(
          children: [
            _buildStatusBadge(context, order.status.name, order.status.color ?? '#6366f1'),
            const SizedBox(width: 8),
            if (order.paymentStatus != null)
              _buildStatusBadge(context, order.paymentStatus!.name, '#10B981'),
          ],
        ),
        const SizedBox(height: 24),

        // Order info row
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'order number'),
                order.orderNumber,
                Icons.tag_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'created'),
                _formatDate(df, order.createdAt),
                Icons.calendar_today_rounded,
                bottomPadding: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Pricing row
        _buildSectionTitle(context, 'pricing'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildPriceTile(context, 'subtotal', order.subtotal, Icons.shopping_cart_outlined)),
            const SizedBox(width: 8),
            Expanded(child: _buildPriceTile(context, 'discount', order.discountAmount, Icons.discount_outlined, color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildPriceTile(context, 'shipping', order.shippingCost, Icons.local_shipping_outlined)),
            const SizedBox(width: 8),
            Expanded(child: _buildPriceTile(context, 'tax', order.taxAmount, Icons.receipt_outlined)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.primaryColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded, color: theme.primaryColor, size: 20),
              const SizedBox(width: 12),
              Text(
                AdminLocalizations.translate(context, 'total'),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              Text(
                '${order.total} EGP',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Payment method
        if (order.paymentMethod != null) ...[
          Row(
            children: [
              Expanded(
                child: AdminDetailsDialog.buildDetailRow(
                  context,
                  AdminLocalizations.translate(context, 'payment method'),
                  '${order.paymentMethod!.name}${order.paymentMethod!.type != null ? ' (${order.paymentMethod!.type})' : ''}',
                  Icons.payment_rounded,
                  bottomPadding: 0,
                ),
              ),
              if (order.couponCode != null && order.couponCode!.isNotEmpty)
                const SizedBox(width: 16),
              if (order.couponCode != null && order.couponCode!.isNotEmpty)
                Expanded(
                  child: AdminDetailsDialog.buildDetailRow(
                    context,
                    AdminLocalizations.translate(context, 'coupon'),
                    order.couponCode!,
                    Icons.local_offer_rounded,
                    bottomPadding: 0,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],

        // Address
        if (order.address != null)
          _buildAddressSection(context, order.address!, isDark),

        // Items
        if (order.items.isNotEmpty)
          _buildItemsSection(context, order.items, isDark),

        // Notes
        if (order.notes != null && order.notes!.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildSectionTitle(context, 'notes'),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(order.notes!, style: theme.textTheme.bodyMedium),
          ),
        ],

        // Timeline
        _buildTimeline(context, order, isDark),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String label, String hexColor) {
    final color = _parseColor(hexColor);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Text(
      AdminLocalizations.translate(context, label),
      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
    );
  }

  Widget _buildPriceTile(BuildContext context, String label, String amount, IconData icon, {Color? color}) {
    final theme = Theme.of(context);
    final c = color ?? theme.textTheme.bodySmall?.color;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: (theme.brightness == Brightness.dark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c?.withValues(alpha: 0.5)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AdminLocalizations.translate(context, label),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c?.withValues(alpha: 0.6),
                ),
              ),
              Text(
                '$amount EGP',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context, AddressDetail addr, bool isDark) {
    final theme = Theme.of(context);
    final gov = addr.governorate;
    final city = addr.city;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'delivery address'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddressLine(context, addr.name ?? '', Icons.person_outline),
              if (addr.mobile != null) _buildAddressLine(context, addr.mobile!, Icons.phone_outlined),
              const SizedBox(height: 8),
              _buildAddressLine(
                context,
                [
                  if (addr.building != null && addr.building!.isNotEmpty) '${AdminLocalizations.translate(context, 'building')}: ${addr.building}',
                  if (addr.floor != null && addr.floor!.isNotEmpty) '${AdminLocalizations.translate(context, 'floor')}: ${addr.floor}',
                  if (addr.apartment != null && addr.apartment!.isNotEmpty) '${AdminLocalizations.translate(context, 'apartment')}: ${addr.apartment}',
                  if (addr.street != null && addr.street!.isNotEmpty) '${AdminLocalizations.translate(context, 'street')}: ${addr.street}',
                  if (addr.area != null && addr.area!.isNotEmpty) '${AdminLocalizations.translate(context, 'area')}: ${addr.area}',
                  if (addr.block != null && addr.block!.isNotEmpty) '${AdminLocalizations.translate(context, 'block')}: ${addr.block}',
                ].where((e) => e != null && e.isNotEmpty).join(', '),
                Icons.location_on_outlined,
              ),
              if (gov != null || city != null) ...[
                const SizedBox(height: 4),
                _buildAddressLine(
                  context,
                  [
                    if (city != null)
                      switch (Localizations.localeOf(context).languageCode) {
                        'ar' => city.nameAr ?? city.nameEn ?? city.name,
                        _ => city.nameEn ?? city.nameAr ?? city.name,
                      },
                    if (gov != null)
                      switch (Localizations.localeOf(context).languageCode) {
                        'ar' => gov.nameAr ?? gov.nameEn ?? gov.name,
                        _ => gov.nameEn ?? gov.nameAr ?? gov.name,
                      },
                  ].where((e) => e.isNotEmpty).join(' - '),
                  Icons.map_outlined,
                ),
              ],
              if (addr.notes != null && addr.notes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildAddressLine(context, addr.notes!, Icons.notes_rounded),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAddressLine(BuildContext context, String text, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(BuildContext context, List<OrderItemDetail> items, bool isDark) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'items'),
        const SizedBox(height: 12),
        ...items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productNameAr ?? item.productName,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (item.productNameAr != null)
                      Text(
                        item.productName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('${AdminLocalizations.translate(context, 'qty')}: ${item.quantity}',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              Text(
                '${item.total} EGP',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: theme.primaryColor),
              ),
            ],
          ),
        )),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context, OrderDetail order, bool isDark) {
    final theme = Theme.of(context);
    final df = DateFormat('yyyy-MM-dd HH:mm');
    final events = <_TimelineEvent>[];

    events.add(_TimelineEvent(
      label: AdminLocalizations.translate(context, 'created'),
      date: _formatDate(df, order.createdAt),
      icon: Icons.add_circle_outline,
    ));

    if (order.shippedAt != null && order.shippedAt!.isNotEmpty) {
      events.add(_TimelineEvent(
        label: AdminLocalizations.translate(context, 'shipped'),
        date: _formatDate(df, order.shippedAt!),
        icon: Icons.local_shipping_rounded,
      ));
    }
    if (order.deliveredAt != null && order.deliveredAt!.isNotEmpty) {
      events.add(_TimelineEvent(
        label: AdminLocalizations.translate(context, 'delivered'),
        date: _formatDate(df, order.deliveredAt!),
        icon: Icons.check_circle_rounded,
      ));
    }
    if (order.cancelledAt != null && order.cancelledAt!.isNotEmpty) {
      events.add(_TimelineEvent(
        label: AdminLocalizations.translate(context, 'cancelled'),
        date: _formatDate(df, order.cancelledAt!),
        icon: Icons.cancel_rounded,
        isError: true,
      ));
    }

    if (events.length <= 1) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'order timeline'),
        const SizedBox(height: 12),
        ...List.generate(events.length, (i) {
          final e = events[i];
          final isLast = i == events.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Column(
                    children: [
                      Icon(e.icon, size: 18, color: e.isError ? Colors.red : theme.primaryColor),
                      if (!isLast)
                        Expanded(
                          child: VerticalDivider(
                            width: 24,
                            thickness: 1.5,
                            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                        Text(e.date, style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                          fontSize: 11,
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        if (order.cancelledReason != null && order.cancelledReason!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.red.shade400),
                const SizedBox(width: 8),
                Expanded(child: Text(order.cancelledReason!,
                  style: TextStyle(fontSize: 12, color: Colors.red.shade700, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateFormat df, String raw) {
    try {
      return df.format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  Color _parseColor(String hex) {
    try {
      if (!hex.startsWith('#')) hex = '#$hex';
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }
}

class _TimelineEvent {
  final String label;
  final String date;
  final IconData icon;
  final bool isError;

  _TimelineEvent({
    required this.label,
    required this.date,
    required this.icon,
    this.isError = false,
  });
}
