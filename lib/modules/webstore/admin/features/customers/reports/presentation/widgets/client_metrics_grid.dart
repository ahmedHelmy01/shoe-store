import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/features/dashboard/presentation/widgets/stat_card.dart';

class ClientMetricsGrid extends StatelessWidget {
  final int totalClients;
  final int totalOrders;
  final double totalSpent;
  final int activeClients;
  final bool showReportData;
  final String? periodOrders;
  final String? periodSpent;

  const ClientMetricsGrid({
    super.key,
    this.totalClients = 0,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    this.activeClients = 0,
    this.showReportData = false,
    this.periodOrders,
    this.periodSpent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double ratio;

        if (constraints.maxWidth > 1100) {
          crossAxisCount = 4;
          ratio = 3.6;
        } else if (constraints.maxWidth > 700) {
          crossAxisCount = 2;
          ratio = 2.0;
        } else {
          crossAxisCount = 2;
          ratio = 1.2;
        }
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: ratio,
          children: [
            StatCard(
              title: AdminLocalizations.translate(context, showReportData ? 'period orders' : 'total clients'),
              value: showReportData ? (periodOrders ?? '0') : totalClients.toString(),
              deltaPercent: 0,
              positive: true,
              icon: Icons.people_alt_rounded,
              color: AppColors.primary,
            ),
            StatCard(
              title: AdminLocalizations.translate(context, showReportData ? 'period spent' : 'total orders'),
              value: showReportData
                  ? '${periodSpent ?? "0"} ${AppConstants.currency}'
                  : totalOrders.toString(),
              deltaPercent: 0,
              positive: true,
              icon: Icons.shopping_bag_rounded,
              color: AppColors.secondary,
            ),
            StatCard(
              title: AdminLocalizations.translate(context, showReportData ? 'total orders' : 'total spent'),
              value: showReportData
                  ? totalOrders.toString()
                  : '${totalSpent.toStringAsFixed(2)} ${AppConstants.currency}',
              deltaPercent: 0,
              positive: true,
              icon: Icons.account_balance_wallet_rounded,
              color: AppColors.info,
            ),
            StatCard(
              title: AdminLocalizations.translate(context, showReportData ? 'total spent' : 'active clients'),
              value: showReportData
                  ? '${totalSpent.toStringAsFixed(2)} ${AppConstants.currency}'
                  : activeClients.toString(),
              deltaPercent: 0,
              positive: true,
              icon: Icons.how_to_reg_rounded,
              color: AppColors.warning,
            ),
          ],
        );
      },
    );
  }
}
