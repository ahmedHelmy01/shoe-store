import 'package:flutter/material.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'base_report_view.dart';

class ExpiredReportView extends StatelessWidget {
  const ExpiredReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseReportView(
      title: 'Expired Points Report',
      endpoint: ApiEndpoints.webstore.admin.reportsExpired,
      columns: const ['Customer', 'Points Lost', 'Value', 'Expiry Date'],
      rowMapper: (row) => {
        'Customer': row['customer_name'] ?? '—',
        'Points Lost': '${row['points'] ?? 0}',
        'Value': '${row['value'] ?? 0.0}',
        'Expiry Date': '${row['expiry_date'] ?? '—'}',
      },
    );
  }
}
