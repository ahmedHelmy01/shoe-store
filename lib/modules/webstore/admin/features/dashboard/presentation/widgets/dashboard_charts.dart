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
      margin: const EdgeInsets.all(12),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.5)),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: fg.withValues(alpha: 0.05), dashArray: const [5, 5]),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.5)),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: AppColors.primary,
        textStyle: const TextStyle(color: Colors.white),
        header: 'Sales',
      ),
      series: <CartesianSeries<AdminSalesPoint, String>>[
        SplineAreaSeries<AdminSalesPoint, String>(
          dataSource: points,
          xValueMapper: (AdminSalesPoint p, _) => df.format(p.day),
          yValueMapper: (AdminSalesPoint p, _) => p.revenue,
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.4),
              AppColors.primary.withValues(alpha: 0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: AppColors.primary,
          borderWidth: 3,
          markerSettings: const MarkerSettings(
            isVisible: true,
            width: 6,
            height: 6,
            color: AppColors.primary,
            borderWidth: 2,
            borderColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class OrdersChart extends StatelessWidget {
  final List<AdminSalesPoint> points;
  final List<String>? labels;
  final String? title;
  const OrdersChart({super.key, required this.points, this.labels, this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fg = theme.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black);

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      margin: const EdgeInsets.all(12),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.5)),
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: fg.withValues(alpha: 0.05), dashArray: const [5, 5]),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg.withValues(alpha: 0.5)),
      ),
      tooltipBehavior: TooltipBehavior(enable: true, color: AppColors.secondary),
      series: <CartesianSeries<AdminSalesPoint, String>>[
        ColumnSeries<AdminSalesPoint, String>(
          dataSource: points,
          xValueMapper: (AdminSalesPoint p, int index) => 
              (labels != null && index < labels!.length) ? labels![index] : DateFormat('MM/dd').format(p.day),
          yValueMapper: (AdminSalesPoint p, _) => p.orders,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          gradient: LinearGradient(
            colors: [
              AppColors.secondary,
              AppColors.secondary.withValues(alpha: 0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
      margin: EdgeInsets.zero,
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      palette: [
        AppColors.primary,
        AppColors.secondary,
        AppColors.accent,
        AppColors.info,
        AppColors.success,
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CircularSeries<AdminStatusShare, String>>[
        DoughnutSeries<AdminStatusShare, String>(
          dataSource: items,
          xValueMapper: (AdminStatusShare d, _) => d.status,
          yValueMapper: (AdminStatusShare d, _) => d.value,
          dataLabelMapper: (AdminStatusShare d, _) => '${d.value.toStringAsFixed(1)}%',
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: theme.textTheme.bodySmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w900,
            ),
          ),
          innerRadius: '70%',
          radius: '75%',
          enableTooltip: true,
          animationDuration: 1500,
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0),
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: fg, fontWeight: FontWeight.bold),
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<AdminCategoryShare, String>>[
        BarSeries<AdminCategoryShare, String>(
          dataSource: items,
          xValueMapper: (AdminCategoryShare c, _) => c.name,
          yValueMapper: (AdminCategoryShare c, _) => c.value,
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.5),
            ],
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: theme.textTheme.bodySmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
