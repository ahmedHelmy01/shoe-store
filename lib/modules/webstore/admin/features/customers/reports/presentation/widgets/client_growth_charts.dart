import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
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
                    title: AdminLocalizations.translate(context, 'Customer Growth (Last 6 Months)'),
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
                    title: AdminLocalizations.translate(context, 'Customer Segments'),
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
                title: AdminLocalizations.translate(context, 'Customer Growth (Last 6 Months)'),
                child: _buildGrowthChart(context),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 340,
              child: GlassPanel(
                title: AdminLocalizations.translate(context, 'Customer Segments'),
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
      ChartData(AdminLocalizations.translate(context, 'Jan'), 8500),
      ChartData(AdminLocalizations.translate(context, 'Feb'), 9200),
      ChartData(AdminLocalizations.translate(context, 'Mar'), 9800),
      ChartData(AdminLocalizations.translate(context, 'Apr'), 10500),
      ChartData(AdminLocalizations.translate(context, 'May'), 11400),
      ChartData(AdminLocalizations.translate(context, 'Jun'), 12458),
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
          name: AdminLocalizations.translate(context, 'Clients'),
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
      ChartData(AdminLocalizations.translate(context, 'VIP'), 15),
      ChartData(AdminLocalizations.translate(context, 'Loyal'), 35),
      ChartData(AdminLocalizations.translate(context, 'Regular'), 40),
      ChartData(AdminLocalizations.translate(context, 'New'), 10),
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
