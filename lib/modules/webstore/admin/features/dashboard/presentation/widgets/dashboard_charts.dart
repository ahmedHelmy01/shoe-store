import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:erp/core/constants/app_constants.dart';
import '../../data/models/admin_dashboard_models.dart';

class SalesChart extends StatelessWidget {
  final List<AdminSalesPoint> points;
  const SalesChart({super.key, required this.points});

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
          xValueMapper: (AdminSalesPoint p, _) => df.format(p.day),
          yValueMapper: (AdminSalesPoint p, _) => p.revenue,
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.45),
              AppColors.primary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: AppColors.primary,
          borderWidth: 2.5,
          markerSettings: const MarkerSettings(isVisible: true, width: 4, height: 4),
        ),
      ],
    );
  }
}

class OrdersChart extends StatelessWidget {
  final List<AdminSalesPoint> points;
  const OrdersChart({super.key, required this.points});

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
          xValueMapper: (AdminSalesPoint p, _) => df.format(p.day),
          yValueMapper: (AdminSalesPoint p, _) => p.orders,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          color: AppColors.secondary.withValues(alpha: 0.8),
        ),
      ],
    );
  }
}

class StatusDonut extends StatelessWidget {
  final List<AdminStatusShare> items;
  const StatusDonut({super.key, required this.items});

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
          xValueMapper: (AdminStatusShare d, _) => d.status,
          yValueMapper: (AdminStatusShare d, _) => d.value,
          dataLabelMapper: (AdminStatusShare d, _) => '${d.value.toStringAsFixed(0)}%',
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: theme.textTheme.bodySmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w800,
            ),
          ),
          innerRadius: '65%',
          radius: '85%',
        ),
      ],
    );
  }
}

class TopCategoriesChart extends StatelessWidget {
  final List<AdminCategoryShare> items;
  const TopCategoriesChart({super.key, required this.items});

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
        BarSeries<AdminCategoryShare, String>(
          dataSource: items,
          xValueMapper: (AdminCategoryShare c, _) => c.name,
          yValueMapper: (AdminCategoryShare c, _) => c.value,
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
          color: AppColors.primary.withValues(alpha: 0.8),
        ),
      ],
    );
  }
}
