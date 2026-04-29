import 'package:erp/modules/webstore/admin/features/dashboard/data/models/admin_dashboard_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import '../view_model/admin_dashboard_view_model.dart';
import '../widgets/glass_panel.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stats_grid.dart';
import '../widgets/dashboard_charts_layout.dart';
class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    
    final dashboardState = ref.watch(adminDashboardProvider);

    if (dashboardState.isLoading && dashboardState.statistics == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dashboardState.error != null && dashboardState.statistics == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Error: ${dashboardState.error}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(adminDashboardProvider.notifier).getStatistics(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final stats = dashboardState.statistics!;

    final totalRevenueFromTop = stats.topProducts.fold<double>(0, (prev, e) => prev + e.totalRevenue);
    
    final revenueShareItems = stats.topProducts.map((p) {
      final share = totalRevenueFromTop > 0 ? (p.totalRevenue / totalRevenueFromTop) * 100 : 0.0;
      return AdminStatusShare(status: p.productName, value: share);
    }).toList();

    final productQtyItems = stats.topProducts.map((p) {
      return AdminSalesPoint(day: DateTime.now(), revenue: p.totalRevenue, orders: p.totalQty);
    }).toList();

    return RefreshIndicator(
      onRefresh: () => ref.read(adminDashboardProvider.notifier).getStatistics(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(
              greeting: _getGreetingString(),
              isLoading: dashboardState.isLoading,
            ),
            const SizedBox(height: 32),
            DashboardStatsGrid(
              stats: stats,
              isMobile: isMobile,
              width: width,
            ),
            const SizedBox(height: 32),
            DashboardChartsLayout(
              charts: [
                GlassPanel(
                  title: 'Inventory Movement (Top Products Qty)',
                  child: OrdersChart(points: productQtyItems),
                ),
                GlassPanel(
                  title: 'Financial Contribution (Revenue Share)',
                  child: StatusDonut(items: revenueShareItems),
                ),
                GlassPanel(
                  title: 'Revenue Performance (By Product)',
                  child: TopCategoriesChart(
                    items: stats.topProducts
                        .map((e) => AdminCategoryShare(name: e.productName, value: e.totalRevenue))
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getGreetingString() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}


