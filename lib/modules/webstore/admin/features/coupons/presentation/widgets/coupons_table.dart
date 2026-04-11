import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import '../../data/models/coupon_row.dart';

class CouponsTable extends StatelessWidget {
  final List<CouponRow> items;

  const CouponsTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CouponRow>(
      rows: items,
      idOf: (c) => '${c.id}',
      exportBaseName: 'coupons',
      searchHint: 'Search coupons…',
      searchText: (c) => '${c.id} ${c.code} ${c.type}',
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
          cell: (_, c) => Text(c.code, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 160,
        ),
        AdminColumn<CouponRow>(
          title: 'Type',
          sortable: true,
          sortValue: (c) => c.type,
          exportValue: (c) => c.type,
          cell: (_, c) => Text(c.type),
          width: 120,
        ),
        AdminColumn<CouponRow>(
          title: 'Value',
          sortable: true,
          sortValue: (c) => c.value,
          exportValue: (c) => '${c.value}',
          cell: (_, c) => Text('${c.value}'),
          width: 100,
        ),
      ],
    );
  }
}
