import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/features/dashboard/presentation/widgets/stat_card.dart';

class ClientMetricsGrid extends StatelessWidget {
  const ClientMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          const StatCard(
            title: 'Total Clients',
            value: '12,458',
            deltaPercent: 12,
            positive: true,
            icon: Icons.people_alt_rounded,
          ),
          const StatCard(
            title: 'Active Clients',
            value: '8,234',
            deltaPercent: 5,
            positive: true,
            icon: Icons.how_to_reg_rounded,
          ),
          const StatCard(
            title: 'New This Month',
            value: '452',
            deltaPercent: 2,
            positive: false,
            icon: Icons.person_add_alt_1_rounded,
          ),
          StatCard(
            title: 'Avg. Revenue/Client',
            value: '850 ${AppConstants.currency}',
            deltaPercent: 8,
            positive: true,
            icon: Icons.monetization_on_rounded,
          ),
        ],
      ),
    );
  }
}
