import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/modules/webstore/admin/features/users/data/models/user_row.dart';
import 'package:erp/modules/webstore/admin/features/customers/reports/data/models/client_report_models.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/dashboard/presentation/widgets/glass_panel.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import '../widgets/client_metrics_grid.dart';

class ClientReportsView extends ConsumerStatefulWidget {
  const ClientReportsView({super.key});

  @override
  ConsumerState<ClientReportsView> createState() => _ClientReportsViewState();
}

class _ClientReportsViewState extends ConsumerState<ClientReportsView> {
  UserRow? _selectedClient;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final _dateFromCtrl = TextEditingController();
  final _dateToCtrl = TextEditingController();
  ClientReport? _report;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _dateFromCtrl.dispose();
    _dateToCtrl.dispose();
    super.dispose();
  }

  void _pickDate(TextEditingController ctrl, bool isFrom) async {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? (_dateFrom ?? today) : (_dateTo ?? today),
      firstDate: DateTime(2020),
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A73E8),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF1A73E8)),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
          if (_dateTo != null && _dateTo!.isBefore(_dateFrom!)) {
            _dateTo = _dateFrom;
            _dateToCtrl.text = _dateFromCtrl.text;
          }
        } else {
          _dateTo = picked;
          if (_dateFrom != null && _dateTo!.isBefore(_dateFrom!)) {
            _dateFrom = _dateTo;
            _dateFromCtrl.text = _dateToCtrl.text;
          }
        }
        ctrl.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _saveReport() async {
    if (_selectedClient == null || _dateFrom == null || _dateTo == null) return;

    setState(() { _isLoading = true; _error = null; _report = null; });

    final repo = ref.read(clientReportsRepositoryProvider);
    final result = await repo.getClientReport(
      customerId: _selectedClient!.id,
      dateFrom: _dateFromCtrl.text,
      dateTo: _dateToCtrl.text,
    );

    result.when(
      success: (report) => setState(() { _report = report; _isLoading = false; }),
      failure: (e) => setState(() { _error = e.message; _isLoading = false; }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientsAsync = ref.watch(allClientsProvider);
    final allClients = clientsAsync.whenOrNull(data: (d) => d) ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(title: AdminLocalizations.translate(context, 'Clients Reports')),
          const SizedBox(height: 24),
          _buildFilters(theme, clientsAsync),
          const SizedBox(height: 24),
          if (_error != null)
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 300),
              child: Center(child: _buildError())),
          if (_error == null) ...[
            _buildMetricsSection(theme, allClients),
            const SizedBox(height: 32),
            _buildChartsSection(theme, allClients),
            const SizedBox(height: 32),
            _buildTableSection(theme, allClients),
          ],
        ],
      ),
    );
  }

  Widget _buildFilters(ThemeData theme, AsyncValue<List<UserRow>> clientsAsync) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (theme.brightness == Brightness.dark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AdminLocalizations.translate(context, 'client report'),
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          clientsAsync.when(
            data: (clients) => AppDropdown<UserRow>(
              label: AdminLocalizations.translate(context, 'client'),
              hint: AdminLocalizations.translate(context, 'select a client...'),
              value: _selectedClient,
              items: clients.map((c) => DropdownMenuItem(
                value: c,
                child: Text('${c.name} ${c.email != null ? "(${c.email})" : ""}'),
              )).toList(),
              onChanged: (v) => setState(() => _selectedClient = v),
            ),
            loading: () => AppDropdown<UserRow>(
              label: AdminLocalizations.translate(context, 'client'),
              items: [],
              hint: AdminLocalizations.translate(context, 'loading clients...'),
            ),
            error: (e, _) => Text('$e', style: TextStyle(color: theme.colorScheme.error)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDate(_dateFromCtrl, true),
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _dateFromCtrl,
                      label: AdminLocalizations.translate(context, 'date from'),
                      hint: 'YYYY-MM-DD',
                      suffixIcon: const Icon(Icons.calendar_month_rounded, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDate(_dateToCtrl, false),
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _dateToCtrl,
                      label: AdminLocalizations.translate(context, 'date to'),
                      hint: 'YYYY-MM-DD',
                      suffixIcon: const Icon(Icons.calendar_month_rounded, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _selectedClient != null && _dateFrom != null && _dateTo != null && !_isLoading
                    ? _saveReport : null,
                icon: _isLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_rounded),
                label: Text(AdminLocalizations.translate(context, 'save')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size(140, 56),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(ThemeData theme, List<UserRow> allClients) {
    final hasReport = _report != null;
    final r = _report;

    int totalClients = allClients.length;
    int totalOrdersAll = allClients.fold(0, (sum, c) => sum + c.ordersCount);
    double totalSpentAll = allClients.fold(0.0, (sum, c) => sum + c.totalSpent);
    int activeClients = allClients.where((c) => c.isActive).length;

    return ClientMetricsGrid(
      totalClients: totalClients,
      totalOrders: hasReport ? (r!.totalOrders ?? 0) : totalOrdersAll,
      totalSpent: hasReport ? (r!.totalSpent ?? 0.0) : totalSpentAll,
      activeClients: activeClients,
      showReportData: hasReport,
      periodOrders: hasReport ? (r!.periodOrders ?? 0).toString() : null,
      periodSpent: hasReport ? r!.periodSpent?.toStringAsFixed(2) ?? "0.00" : null,
    );
  }

  Widget _buildChartsSection(ThemeData theme, List<UserRow> allClients) {
    final isDark = theme.brightness == Brightness.dark;
    final sortedBySpent = List<UserRow>.from(allClients)..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
    final topClients = sortedBySpent.where((c) => c.totalSpent > 0 || c.ordersCount > 0).take(10).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 900;
        final chart1 = _buildTopClientsChart(theme, isDark, topClients);
        final chart2 = _buildDistributionChart(theme, isDark, allClients);

        if (wide) {
          return Row(children: [
            Expanded(child: SizedBox(height: 380, child: chart1)),
            const SizedBox(width: 16),
            Expanded(child: SizedBox(height: 380, child: chart2)),
          ]);
        }
        return Column(children: [
          SizedBox(height: 340, child: chart1),
          const SizedBox(height: 16),
          SizedBox(height: 340, child: chart2),
        ]);
      },
    );
  }

  Widget _buildTopClientsChart(ThemeData theme, bool isDark, List<UserRow> topClients) {
    final hasData = topClients.any((c) => c.totalSpent > 0);
    return GlassPanel(
      title: AdminLocalizations.translate(context, 'top clients by spending'),
      child: hasData
          ? Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelRotation: -30,
                  interval: 1,
                  labelStyle: TextStyle(fontSize: 9, color: theme.textTheme.bodySmall?.color, fontWeight: FontWeight.w600),
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                ),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  majorGridLines: MajorGridLines(width: 0.5, color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)),
                  labelFormat: '{value}',
                  minimum: 0,
                ),
                series: <CartesianSeries<ChartData, String>>[
                  BarSeries<ChartData, String>(
                    dataSource: topClients.map((c) => ChartData(c.name, c.totalSpent)).toList(),
                    xValueMapper: (d, _) => d.x,
                    yValueMapper: (d, _) => d.y,
                    width: 0.6,
                    spacing: 0.3,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                    gradient: LinearGradient(
                      colors: [AppColors.primary.withValues(alpha: 0.7), AppColors.primary],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      textStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x: point.y EGP'),
              ),
            )
          : Center(child: Text(AdminLocalizations.translate(context, 'no data'), style: TextStyle(color: theme.hintColor))),
    );
  }

  Widget _buildDistributionChart(ThemeData theme, bool isDark, List<UserRow> allClients) {
    final activeCount = allClients.where((c) => c.isActive).length;
    final inactiveCount = allClients.length - activeCount;
    final hasData = allClients.isNotEmpty;

    return GlassPanel(
      title: AdminLocalizations.translate(context, 'customer segments'),
      child: hasData
          ? Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap,
                  textStyle: TextStyle(fontSize: 11, color: theme.textTheme.bodySmall?.color),
                ),
                series: <CircularSeries<ChartData, String>>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: [
                      ChartData(AdminLocalizations.translate(context, 'active'), activeCount.toDouble()),
                      ChartData(AdminLocalizations.translate(context, 'inactive'), inactiveCount.toDouble()),
                    ],
                    xValueMapper: (d, _) => d.x,
                    yValueMapper: (d, _) => d.y,
                    innerRadius: '65%',
                    radius: '85%',
                    pointColorMapper: (d, _) => d.y > 0
                        ? (d.x == AdminLocalizations.translate(context, 'active') ? Colors.green : Colors.grey)
                        : Colors.transparent,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: activeCount > 0 || inactiveCount > 0,
                      connectorLineSettings: const ConnectorLineSettings(type: ConnectorType.curve, length: '10%'),
                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                    ),
                    emptyPointSettings: const EmptyPointSettings(mode: EmptyPointMode.gap),
                  ),
                ],
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${allClients.length}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: theme.textTheme.bodyLarge?.color)),
                        Text(AdminLocalizations.translate(context, 'total'), style: TextStyle(fontSize: 11, color: theme.hintColor)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(child: Text(AdminLocalizations.translate(context, 'no data'), style: TextStyle(color: theme.hintColor))),
    );
  }

  Widget _buildTableSection(ThemeData theme, List<UserRow> allClients) {
    final sorted = List<UserRow>.from(allClients)..sort((a, b) => b.ordersCount.compareTo(a.ordersCount));

    return SizedBox(
      height: 500,
      child: AdminDataTable<UserRow>(
        rows: sorted,
        idOf: (r) => '${r.id}',
        exportBaseName: 'clients',
        searchHint: AdminLocalizations.translate(context, 'search clients...'),
        searchText: (r) => '${r.name} ${r.email ?? ""} ${r.mobile ?? ""}',
        columns: [
          AdminColumn<UserRow>(
            title: AdminLocalizations.translate(context, 'name'),
            width: 220,
            sortable: true,
            sortValue: (r) => r.name,
            cell: (_, r) => Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          AdminColumn<UserRow>(
            title: AdminLocalizations.translate(context, 'mobile'),
            width: 150,
            cell: (_, r) => Text(r.mobile ?? '—'),
          ),
          AdminColumn<UserRow>(
            title: AdminLocalizations.translate(context, 'total orders'),
            width: 130,
            sortable: true,
            sortValue: (r) => r.ordersCount,
            cell: (_, r) => Text('${r.ordersCount}'),
          ),
          AdminColumn<UserRow>(
            title: AdminLocalizations.translate(context, 'total spent'),
            width: 160,
            sortable: true,
            sortValue: (r) => r.totalSpent,
            cell: (_, r) => Text('${r.totalSpent.toStringAsFixed(2)} ${AppConstants.currency}'),
          ),
          AdminColumn<UserRow>(
            title: AdminLocalizations.translate(context, 'status'),
            width: 110,
            sortable: true,
            sortValue: (r) => r.isActive ? 'active' : 'inactive',
            cell: (_, r) => AdminStatusBadge(
              isActive: r.isActive,
              activeLabel: AdminLocalizations.translate(context, 'active'),
              inactiveLabel: AdminLocalizations.translate(context, 'inactive'),
            ),
          ),
          AdminColumn<UserRow>(
            title: AdminLocalizations.translate(context, 'joined'),
            width: 140,
            sortable: true,
            sortValue: (r) => r.createdAt?.toIso8601String(),
            cell: (_, r) => Text(
              r.createdAt != null
                  ? '${r.createdAt!.year}-${r.createdAt!.month.toString().padLeft(2, '0')}-${r.createdAt!.day.toString().padLeft(2, '0')}'
                  : '—',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
        cardBuilder: (context, r) => _ClientCard(client: r),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Column(children: [
        Icon(Icons.error_outline_rounded, size: 48, color: Colors.red[400]),
        const SizedBox(height: 16),
        Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final UserRow client;
  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(client.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
            AdminStatusBadge(isActive: client.isActive),
          ]),
          const SizedBox(height: 12),
          _infoRow(context, AdminLocalizations.translate(context, 'total orders'), '${client.ordersCount}', Icons.shopping_bag_outlined),
          const SizedBox(height: 8),
          _infoRow(context, AdminLocalizations.translate(context, 'total spent'), '${client.totalSpent.toStringAsFixed(2)} ${AppConstants.currency}', Icons.payments_outlined),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Row(children: [
      Icon(icon, size: 16, color: theme.hintColor),
      const SizedBox(width: 8),
      Text('$label:', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
      const Spacer(),
      Text(value, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor)),
    ]);
  }
}
