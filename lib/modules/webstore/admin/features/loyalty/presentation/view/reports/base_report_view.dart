import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/models/points_report_model.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/presentation/view_model/loyalty_admin_providers.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class BaseReportView extends ConsumerWidget {
  final String title;
  final String endpoint;
  final List<String> columns;
  final Map<String, dynamic> Function(Map<String, dynamic> row) rowMapper;

  const BaseReportView({
    super.key,
    required this.title,
    required this.endpoint,
    required this.columns,
    required this.rowMapper,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(reportProvider(endpoint));
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(reportProvider(endpoint));
        await ref.read(reportProvider(endpoint).future);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminPageHeader(title: AdminLocalizations.translate(context, title)),
            const SizedBox(height: 24),
            reportAsync.when(
              data: (report) => _buildContent(context, theme, report),
              loading: () => _buildLoading(),
              error: (e, _) => _buildError(context, '$e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, PointsReportModel report) {
    final mappedRows = report.rows.map((r) => rowMapper(r)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryCards(context, theme, report),
        const SizedBox(height: 24),
        SizedBox(
          height: 500,
          child: AdminDataTable<Map<String, dynamic>>(
            rows: mappedRows,
            idOf: (row) => row.hashCode.toString(),
            exportBaseName: title.replaceAll(' ', '_').toLowerCase(),
            searchHint: AdminLocalizations.translate(context, 'search…'),
            searchText: (row) => row.values.join(' '),
            columns: columns.map((col) {
              return AdminColumn<Map<String, dynamic>>(
                title: AdminLocalizations.translate(context, col),
                width: 150,
                sortable: true,
                sortValue: (row) => '${row[col] ?? ''}',
                exportValue: (row) => '${row[col] ?? ''}',
                cell: (_, row) {
                  return Text(
                    '${row[col] ?? '—'}',
                    style: theme.textTheme.bodySmall,
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(BuildContext context, ThemeData theme, PointsReportModel report) {
    final isDark = theme.brightness == Brightness.dark;
    final items = [
      _CardData(AdminLocalizations.translate(context, 'Total Points'), '${report.totalPoints}', Icons.stars_rounded, AppColors.primary),
      _CardData(AdminLocalizations.translate(context, 'Total Value'), '${report.totalValue.toStringAsFixed(2)} ${AppConstants.currency}', Icons.attach_money_rounded, AppColors.success),
      _CardData(AdminLocalizations.translate(context, 'Customers'), '${report.customerCount}', Icons.people_rounded, AppColors.info),
      _CardData(AdminLocalizations.translate(context, 'Transactions'), '${report.transactionCount}', Icons.swap_horiz_rounded, AppColors.warning),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 800;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((item) {
            return SizedBox(
              width: wide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
              child: Container(
                padding: const EdgeInsets.all(20),
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                          const SizedBox(height: 4),
                          Text(item.value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(BuildContext context, String error) {
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
        Text(error, textAlign: TextAlign.center, style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _CardData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _CardData(this.label, this.value, this.icon, this.color);
}
