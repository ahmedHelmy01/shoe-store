import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import '../widgets/client_metrics_grid.dart';
import '../widgets/client_growth_charts.dart';
import '../widgets/top_spenders_table.dart';

class ClientReportsView extends StatelessWidget {
  const ClientReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title: 'Clients Reports',
          ),
          SizedBox(height: 24),
          
          // --- Key Metrics ---
          ClientMetricsGrid(),
          
          SizedBox(height: 32),
          
          // --- Charts Row 1 ---
          AppAnimation(
            child: ClientGrowthCharts(),
          ),
          
          SizedBox(height: 32),
          
          // --- Top Spenders Table ---
          AppAnimation(
            delay: Duration(milliseconds: 200),
            child: TopSpendersTable(),
          ),
        ],
      ),
    );
  }
}
