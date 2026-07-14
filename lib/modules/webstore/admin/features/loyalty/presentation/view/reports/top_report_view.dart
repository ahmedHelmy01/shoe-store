import 'package:flutter/material.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'base_report_view.dart';

class TopReportView extends StatelessWidget {
  const TopReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseReportView(
      title: 'Top Customers Report',
      endpoint: ApiEndpoints.webstore.admin.reportsTop,
      columns: const ['Customer', 'Earned', 'Used', 'Expired', 'Balance', 'Value'],
      rowMapper: (row) => {
        'Customer': row['customer_name'] ?? '—',
        'Earned': '${row['earned'] ?? 0}',
        'Used': '${row['used'] ?? 0}',
        'Expired': '${row['expired'] ?? 0}',
        'Balance': '${row['balance'] ?? 0}',
        'Value': '${row['value'] ?? 0.0}',
      },
    );
  }
}
