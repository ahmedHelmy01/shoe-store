import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class CouponsTable extends StatelessWidget {
  final List<CouponRow> items;
  final Function(CouponRow c) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, CouponRow c)? cardBuilder;

  const CouponsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CouponRow>(
      rows: items,
      idOf: (c) => '${c.id}',
      exportBaseName: 'coupons',
      searchHint: AdminLocalizations.translate(context, 'search coupons by code…'),
      searchText: (c) => '${c.id} ${c.code}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<CouponRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (c) => c.id,
          exportValue: (c) => '${c.id}',
          cell: (_, c) => Text('${c.id}'),
          width: 80,
        ),
        AdminColumn<CouponRow>(
          title: AdminLocalizations.translate(context, 'code'),
          sortable: true,
          sortValue: (c) => c.code,
          exportValue: (c) => c.code,
          cell: (_, c) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
            ),
            child: Text(c.code, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, letterSpacing: 0.5)),
          ),
          width: 180,
        ),
        AdminColumn<CouponRow>(
          title: AdminLocalizations.translate(context, 'discount'),
          sortable: true,
          sortValue: (c) => c.discountValue,
          exportValue: (c) => c.isPercentage ? '${c.discountValue}%' : '\$${c.discountValue}',
          cell: (_, c) => Text(
            c.isPercentage ? '${c.discountValue}%' : '\$${c.discountValue}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          width: 120,
        ),
        AdminColumn<CouponRow>(
          title: AdminLocalizations.translate(context, 'min order'),
          sortable: true,
          sortValue: (c) => c.minimumOrderValue,
          exportValue: (c) => '${c.minimumOrderValue}',
          cell: (_, c) => Text('${c.minimumOrderValue}'),
          width: 100,
        ),
        AdminColumn<CouponRow>(
          title: AdminLocalizations.translate(context, 'max uses'),
          sortable: true,
          sortValue: (c) => c.maxUses,
          exportValue: (c) => '${c.maxUses}',
          cell: (_, c) => Text('${c.maxUses}'),
          width: 90,
        ),
        AdminColumn<CouponRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (c) => c.isActive ? 1 : 0,
          exportValue: (c) => c.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, c) => AdminStatusBadge(isActive: c.isActive),
          width: 100,
        ),
        AdminColumn<CouponRow>(
          title: AdminLocalizations.translate(context, 'actions'),
          cell: (_, c) => AdminTableActionsCell<CouponRow>(
            row: c,
            onView: (c) {
              showDialog(
                context: context,
                builder: (_) => CouponDetailsDialog(coupon: c),
              );
            },
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
            confirmBeforeDelete: false,
          ),
          width: 130,
        ),
      ],
    );
  }
}

class CouponDetailsDialog extends StatelessWidget {
  final CouponRow coupon;
  const CouponDetailsDialog({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: AdminLocalizations.translate(context, 'coupon details'),
      id: coupon.id.toString(),
      icon: Icons.confirmation_number_rounded,
      children: [
        if (coupon.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                coupon.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'code'), coupon.code, Icons.qr_code_rounded),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'discount type'), coupon.discountType, Icons.category_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'discount value'), coupon.isPercentage ? '${coupon.discountValue}%' : '\$${coupon.discountValue}', Icons.discount_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'minimum order value'), '${coupon.minimumOrderValue}', Icons.shopping_cart_rounded),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'max uses'), '${coupon.maxUses}', Icons.repeat_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'per customer'), '${coupon.maxUsesPerCustomer}', Icons.person_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'starts at'), coupon.startsAt ?? AdminLocalizations.translate(context, 'n/a'), Icons.event_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'expires at'), coupon.expiresAt ?? AdminLocalizations.translate(context, 'n/a'), Icons.event_busy_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildStatusRow(context, coupon.isActive),
      ],
    );
  }
}
