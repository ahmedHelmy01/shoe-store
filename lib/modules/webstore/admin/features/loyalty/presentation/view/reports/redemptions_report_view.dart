import 'package:flutter/material.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'base_report_view.dart';

class RedemptionsReportView extends StatelessWidget {
  const RedemptionsReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseReportView(
      title: 'Redemptions Report',
      endpoint: ApiEndpoints.webstore.admin.reportsRedemptions,
      columns: const ['Order#', 'Customer', 'Points Used', 'Discount Value', 'Date'],
      rowMapper: (row) => {
        'Order#': '${row['order_id'] ?? '—'}',
        'Customer': row['customer_name'] ?? '—',
        'Points Used': '${row['points'] ?? 0}',
        'Discount Value': '${row['discount_value'] ?? 0.0}',
        'Date': '${row['created_at'] ?? '—'}',
      },
    );
  }
}
