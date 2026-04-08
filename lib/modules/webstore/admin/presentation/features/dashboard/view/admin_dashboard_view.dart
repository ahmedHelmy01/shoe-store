import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:erp/modules/webstore/admin/presentation/models/admin_fake_data.dart';
import 'package:erp/modules/webstore/admin/presentation/models/admin_dashboard_models.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final kpis = AdminFakeData.dashboardKpis();
    final sales = AdminFakeData.dashboardSales();
    final topCats = AdminFakeData.dashboardTopCategories();
    final statuses = AdminFakeData.dashboardOrderStatus();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatCard(
                title: kpis[0].title,
                value: kpis[0].value,
                deltaPercent: kpis[0].deltaPercent,
                positive: kpis[0].positive,
                icon: Icons.receipt_long_rounded,
              ),
              _StatCard(
                title: kpis[1].title,
                value: kpis[1].value,
                deltaPercent: kpis[1].deltaPercent,
                positive: kpis[1].positive,
                icon: Icons.payments_rounded,
              ),
              _StatCard(
                title: kpis[2].title,
                value: kpis[2].value,
                deltaPercent: kpis[2].deltaPercent,
                positive: kpis[2].positive,
                icon: Icons.people_alt_rounded,
              ),
              _StatCard(
                title: kpis[3].title,
                value: kpis[3].value,
                deltaPercent: kpis[3].deltaPercent,
                positive: kpis[3].positive,
                icon: Icons.warning_amber_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AppAnimation.fadeInUp(
              duration: const Duration(milliseconds: 500),
              child: LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= 980;
                  final children = <Widget>[
                    _GlassPanel(
                      title: 'Sales (14 days)',
                      child: _SalesChart(points: sales),
                    ),
                    _GlassPanel(
                      title: 'Orders (14 days)',
                      child: _OrdersChart(points: sales),
                    ),
                    _GlassPanel(
                      title: 'Orders status',
                      child: _StatusDonut(items: statuses),
                    ),
                    _GlassPanel(
                      title: 'Top categories',
                      child: _TopCategoriesChart(items: topCats),
                    ),
                  ];

                  if (!wide) {
                    return Column(
                      children: [
                        for (int i = 0; i < children.length; i++) ...[
                          Expanded(child: children[i]),
                          if (i != children.length - 1) const SizedBox(height: 12),
                        ],
                      ],
                    );
                  }

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      // Wider cards -> less height, so bottom charts fit comfortably.
                      childAspectRatio: 2.10,
                    ),
                    itemCount: children.length,
                    itemBuilder: (context, i) => children[i],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final int deltaPercent;
  final bool positive;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.deltaPercent,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fg = theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black);

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 224, height: 92),
      child: AppAnimation.fadeZoomIn(
        duration: const Duration(milliseconds: 380),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.orangeGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withValues(alpha: 0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: fg.withValues(alpha: 0.70),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            positive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                            size: 16,
                            color: positive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$deltaPercent%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: positive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'vs last',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: fg.withValues(alpha: 0.55),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final String title;
  final Widget child;
  const _GlassPanel({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SalesChart extends StatelessWidget {
  final List<AdminSalesPoint> points;
  const _SalesChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fg = theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black);
    final df = DateFormat('MM/dd');

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: fg.withValues(alpha: 0.08)),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<AdminSalesPoint, String>>[
        SplineAreaSeries<AdminSalesPoint, String>(
          dataSource: points,
          xValueMapper: (p, _) => df.format(p.day),
          yValueMapper: (p, _) => p.revenue,
          gradient: LinearGradient(
            colors: [
              AppColors.primaryOrange.withValues(alpha: 0.45),
              AppColors.primaryOrange.withValues(alpha: 0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: AppColors.primaryOrange,
          borderWidth: 2.5,
          markerSettings: const MarkerSettings(isVisible: true, width: 6, height: 6),
        ),
      ],
    );
  }
}

class _OrdersChart extends StatelessWidget {
  final List<AdminSalesPoint> points;
  const _OrdersChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fg = theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black);
    final df = DateFormat('MM/dd');

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: fg.withValues(alpha: 0.08)),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<AdminSalesPoint, String>>[
        ColumnSeries<AdminSalesPoint, String>(
          dataSource: points,
          xValueMapper: (p, _) => df.format(p.day),
          yValueMapper: (p, _) => p.orders,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppColors.primaryBlue.withValues(alpha: 0.9),
        ),
      ],
    );
  }
}

class _StatusDonut extends StatelessWidget {
  final List<AdminStatusShare> items;
  const _StatusDonut({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fg = theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black);

    return SfCircularChart(
      legend: Legend(isVisible: true, position: LegendPosition.bottom, textStyle: theme.textTheme.bodySmall),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CircularSeries<AdminStatusShare, String>>[
        DoughnutSeries<AdminStatusShare, String>(
          dataSource: items,
          xValueMapper: (d, _) => d.status,
          yValueMapper: (d, _) => d.value,
          dataLabelMapper: (d, _) => '${d.value.toStringAsFixed(0)}%',
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: theme.textTheme.bodySmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w800,
            ),
          ),
          innerRadius: '68%',
          radius: '88%',
        ),
      ],
    );
  }
}

class _TopCategoriesChart extends StatelessWidget {
  final List<AdminCategoryShare> items;
  const _TopCategoriesChart({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fg = theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black);

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: fg.withValues(alpha: 0.08)),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.7)),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<AdminCategoryShare, String>>[
        ColumnSeries<AdminCategoryShare, String>(
          dataSource: items,
          xValueMapper: (c, _) => c.name,
          yValueMapper: (c, _) => c.value,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppColors.primaryBlue.withValues(alpha: 0.9),
        ),
      ],
    );
  }
}

