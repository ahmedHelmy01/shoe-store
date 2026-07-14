import 'package:flutter/material.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'base_report_view.dart';

class MovementReportView extends StatelessWidget {
  const MovementReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseReportView(
      title: 'Movement Report',
      endpoint: ApiEndpoints.webstore.admin.reportsMovement,
      columns: const ['Date', 'Customer', 'Type', 'Points', 'Reason', 'Order'],
      rowMapper: (row) => {
        'Date': '${row['created_at'] ?? '—'}',
        'Customer': row['customer_name'] ?? '—',
        'Type': row['type'] ?? '—',
        'Points': '${row['points'] ?? 0}',
        'Reason': row['reason'] ?? '—',
        'Order': '${row['order_id'] ?? '—'}',
      },
    );
  }
}
