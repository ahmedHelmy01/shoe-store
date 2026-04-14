import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
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
      searchHint: 'Search coupons…',
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
            child: Text(c.code, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          width: 180,
        ),
        AdminColumn<CouponRow>(
          title: 'Discount',
          sortable: true,
          sortValue: (c) => c.discountAmount ?? 0,
          exportValue: (c) => '${c.discountAmount}',
          cell: (_, c) => Text(c.isPercentage ? '${c.discountAmount}%' : '\$${c.discountAmount}'),
          width: 120,
        ),
        AdminColumn<CouponRow>(
          title: 'Actions',
          cell: (_, c) => AdminTableActionsCell<CouponRow>(
            row: c,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
          ),
          width: 130,
        ),
      ],
    );
  }
}
