import 'package:flutter/material.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'base_report_view.dart';

class EarnedReportView extends StatelessWidget {
  const EarnedReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseReportView(
      title: 'Earned Points Report',
      endpoint: ApiEndpoints.webstore.admin.reportsEarned,
      columns: const ['Invoice#', 'Customer', 'Points Earned', 'Value', 'Date'],
      rowMapper: (row) => {
        'Invoice#': '${row['invoice_id'] ?? '—'}',
        'Customer': row['customer_name'] ?? '—',
        'Points Earned': '${row['points'] ?? 0}',
        'Value': '${row['value'] ?? 0.0}',
        'Date': '${row['created_at'] ?? '—'}',
      },
    );
  }
}
