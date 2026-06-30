import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/features/dashboard/presentation/widgets/stat_card.dart';

class ClientMetricsGrid extends StatelessWidget {
  const ClientMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use 4 columns on wide screens, 2 on medium, and 1 on mobile
        int crossAxisCount;
        double ratio;

        if (constraints.maxWidth > 1100) {
          crossAxisCount = 4;
          ratio = 3.6; // Slim 4-column for desktop
        } else if (constraints.maxWidth > 700) {
          crossAxisCount = 2;
          ratio = 2.0; // Compact 2-column for tablet
        } else {
          crossAxisCount = 2;
          ratio = 1.2; // 2-column grid for mobile (fixed overflow)
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
              title: AdminLocalizations.translate(context, 'Total Clients'),
              value: '12,458',
              deltaPercent: 12,
              positive: true,
              icon: Icons.people_alt_rounded,
              color: AppColors.primary,
            ),
            StatCard(
              title: AdminLocalizations.translate(context, 'Active Clients'),
              value: '8,234',
              deltaPercent: 5,
              positive: true,
              icon: Icons.how_to_reg_rounded,
              color: AppColors.secondary,
            ),
            StatCard(
              title: AdminLocalizations.translate(context, 'New This Month'),
              value: '452',
              deltaPercent: 2,
              positive: false,
              icon: Icons.person_add_alt_1_rounded,
              color: AppColors.info,
            ),
            StatCard(
              title: AdminLocalizations.translate(context, 'Avg. Revenue/Client'),
              value: '850 ${AppConstants.currency}',
              deltaPercent: 8,
              positive: true,
              icon: Icons.monetization_on_rounded,
              color: AppColors.warning,
            ),
          ],
        );
      },
    );
  }
}
