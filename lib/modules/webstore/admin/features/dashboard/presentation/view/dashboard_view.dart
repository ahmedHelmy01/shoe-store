import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import '../../data/admin_fake_data.dart';
import '../widgets/stat_card.dart';
import '../widgets/glass_panel.dart';
import '../widgets/dashboard_charts.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    final kpis = AdminDashboardFakeData.dashboardKpis();
    final sales = AdminDashboardFakeData.dashboardSales();
    final topCats = AdminDashboardFakeData.dashboardTopCategories();
    final statuses = AdminDashboardFakeData.dashboardOrderStatus();

    final chartWidgets = <Widget>[
      GlassPanel(
        title: 'Sales (14 days)',
        child: SalesChart(points: sales),
      ),
      GlassPanel(
        title: 'Orders (14 days)',
        child: OrdersChart(points: sales),
      ),
      GlassPanel(
        title: 'Orders status',
        child: StatusDonut(items: statuses),
      ),
      GlassPanel(
        title: 'Top categories',
        child: TopCategoriesChart(items: topCats),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
              children: [
                StatCard(
                  title: kpis[0].title,
                  value: kpis[0].value,
                  deltaPercent: kpis[0].deltaPercent,
                  positive: kpis[0].positive,
                  icon: Icons.receipt_long_rounded,
                ),
                StatCard(
                  title: kpis[1].title,
                  value: kpis[1].value,
                  deltaPercent: kpis[1].deltaPercent,
                  positive: kpis[1].positive,
                  icon: Icons.payments_rounded,
                ),
                StatCard(
                  title: kpis[2].title,
                  value: kpis[2].value,
                  deltaPercent: kpis[2].deltaPercent,
                  positive: kpis[2].positive,
                  icon: Icons.people_alt_rounded,
                ),
                StatCard(
                  title: kpis[3].title,
                  value: kpis[3].value,
                  deltaPercent: kpis[3].deltaPercent,
                  positive: kpis[3].positive,
                  icon: Icons.warning_amber_rounded,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppAnimation.fadeInUp(
            duration: const Duration(milliseconds: 500),
            child: LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth >= 980;
                if (!wide) {
                  return Column(
                    children: chartWidgets
                        .map((w) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: SizedBox(height: 300, child: w),
                            ))
                        .toList(),
                  );
                }

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: chartWidgets,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
