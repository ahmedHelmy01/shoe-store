import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/features/dashboard/presentation/widgets/glass_panel.dart';
import '../../data/models/client_report_models.dart';

class ClientGrowthCharts extends StatelessWidget {
  const ClientGrowthCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 900;
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 360,
                  child: GlassPanel(
                    title: 'Customer Growth (Last 6 Months)',
                    child: _buildGrowthChart(context),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 360,
                  child: GlassPanel(
                    title: 'Customer Segments',
                    child: _buildSegmentsChart(context),
                  ),
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            SizedBox(
              height: 340,
              child: GlassPanel(
                title: 'Customer Growth (Last 6 Months)',
                child: _buildGrowthChart(context),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 340,
              child: GlassPanel(
                title: 'Customer Segments',
                child: _buildSegmentsChart(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGrowthChart(BuildContext context) {
    final data = [
      ChartData('Jan', 8500),
      ChartData('Feb', 9200),
      ChartData('Mar', 9800),
      ChartData('Apr', 10500),
      ChartData('May', 11400),
      ChartData('Jun', 12458),
    ];

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        labelFormat: '{value}',
      ),
      series: <CartesianSeries<ChartData, String>>[
        SplineAreaSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData d, _) => d.x,
          yValueMapper: (ChartData d, _) => d.y,
          name: 'Clients',
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.3),
              AppColors.primary.withValues(alpha: 0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderColor: AppColors.primary,
          borderWidth: 3,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  Widget _buildSegmentsChart(BuildContext context) {
    final data = [
      ChartData('VIP', 15),
      ChartData('Loyal', 35),
      ChartData('Regular', 40),
      ChartData('New', 10),
    ];

    return SfCircularChart(
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      palette: const [
        AppColors.primary,
        AppColors.secondary,
        AppColors.accent,
        AppColors.info,
      ],
      series: <CircularSeries<ChartData, String>>[
        DoughnutSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData d, _) => d.x,
          yValueMapper: (ChartData d, _) => d.y,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          innerRadius: '60%',
        ),
      ],
    );
  }
}
