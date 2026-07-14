import 'package:flutter/material.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'base_report_view.dart';

class CostReportView extends StatelessWidget {
  const CostReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseReportView(
      title: 'Loyalty Cost Report',
      endpoint: ApiEndpoints.webstore.admin.reportsCost,
      columns: const ['Metric', 'Value'],
      rowMapper: (row) => {
        'Metric': row['metric'] ?? '—',
        'Value': '${row['value'] ?? ''}',
      },
    );
  }
}
