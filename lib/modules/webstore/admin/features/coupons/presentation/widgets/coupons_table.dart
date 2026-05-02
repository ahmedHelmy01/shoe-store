import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';

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
      searchHint: 'Search coupons by code…',
      searchText: (c) => '${c.id} ${c.code}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<CouponRow>(
          title: 'ID',
          sortable: true,
          sortValue: (c) => c.id,
          exportValue: (c) => '${c.id}',
          cell: (_, c) => Text('${c.id}'),
          width: 80,
        ),
        AdminColumn<CouponRow>(
          title: 'Code',
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
          title: 'Discount',
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
          title: 'Min Order',
          sortable: true,
          sortValue: (c) => c.minimumOrderValue,
          exportValue: (c) => '${c.minimumOrderValue}',
          cell: (_, c) => Text('${c.minimumOrderValue}'),
          width: 100,
        ),
        AdminColumn<CouponRow>(
          title: 'Max Uses',
          sortable: true,
          sortValue: (c) => c.maxUses,
          exportValue: (c) => '${c.maxUses}',
          cell: (_, c) => Text('${c.maxUses}'),
          width: 90,
        ),
        AdminColumn<CouponRow>(
          title: 'Status',
          sortable: true,
          sortValue: (c) => c.isActive ? 1 : 0,
          exportValue: (c) => c.isActive ? 'Active' : 'Inactive',
          cell: (_, c) => AdminStatusBadge(isActive: c.isActive),
          width: 100,
        ),
        AdminColumn<CouponRow>(
          title: 'Actions',
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
      title: 'Coupon Details',
      id: coupon.id.toString(),
      icon: Icons.confirmation_number_rounded,
      children: [
        AdminDetailsDialog.buildDetailRow(context, 'Code', coupon.code, Icons.qr_code_rounded),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Discount Type', coupon.discountType, Icons.category_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Discount Value', coupon.isPercentage ? '${coupon.discountValue}%' : '\$${coupon.discountValue}', Icons.discount_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Minimum Order Value', '${coupon.minimumOrderValue}', Icons.shopping_cart_rounded),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Max Uses', '${coupon.maxUses}', Icons.repeat_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Per Customer', '${coupon.maxUsesPerCustomer}', Icons.person_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Starts At', coupon.startsAt ?? 'N/A', Icons.event_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Expires At', coupon.expiresAt ?? 'N/A', Icons.event_busy_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildStatusRow(context, coupon.isActive),
      ],
    );
  }
}
