import 'package:flutter/material.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'base_report_view.dart';

class BalancesReportView extends StatelessWidget {
  const BalancesReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseReportView(
      title: 'Balances Report',
      endpoint: ApiEndpoints.webstore.admin.reportsBalances,
      columns: const ['Customer', 'Balance', 'Earned', 'Used', 'Expired', 'Value'],
      rowMapper: (row) => {
        'Customer': row['customer_name'] ?? '—',
        'Balance': '${row['balance'] ?? 0}',
        'Earned': '${row['earned'] ?? 0}',
        'Used': '${row['used'] ?? 0}',
        'Expired': '${row['expired'] ?? 0}',
        'Value': '${row['value'] ?? 0.0}',
      },
    );
  }
}
