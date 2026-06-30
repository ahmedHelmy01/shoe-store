import 'dart:math';
import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'admin_table_models.dart';

class AdminTableContent<T> extends StatelessWidget {
  final List<T> rows;
  final List<AdminColumn<T>> columns;
  final AdminIdOf<T> idOf;
  final Set<String> selected;
  final ValueChanged<String> onToggleSelection;
  final ValueChanged<bool?> onToggleAll;
  final bool allOnPageSelected;
  final int? sortIndex;
  final bool sortAsc;
  final void Function(int index, bool asc) onSort;
  final Widget Function(BuildContext context, T row)? cardBuilder;

  const AdminTableContent({
    super.key,
    required this.rows,
    required this.columns,
    required this.idOf,
    required this.selected,
    required this.onToggleSelection,
    required this.onToggleAll,
    required this.allOnPageSelected,
    this.sortIndex,
    this.sortAsc = true,
    required this.onSort,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile && cardBuilder != null) {
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => cardBuilder!(context, rows[i]),
          );
        }

        final zebraA = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03);
        final zebraB = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.015);

        final table = DataTable(
          headingRowColor: WidgetStatePropertyAll(
            (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
          ),
          showCheckboxColumn: false,
          horizontalMargin: 16,
          columnSpacing: 18,
          headingRowHeight: 54,
          dataRowMinHeight: 52,
          dataRowMaxHeight: 64,
          sortAscending: sortAsc,
          sortColumnIndex: sortIndex == null ? null : sortIndex! + 1,
          columns: [
            DataColumn(
              label: Checkbox(
                value: allOnPageSelected,
                onChanged: onToggleAll,
              ),
            ),
            for (int i = 0; i < columns.length; i++)
              DataColumn(
                onSort: columns[i].sortable ? (_, asc) => onSort(i, asc) : null,
                label: SizedBox(
                  width: columns[i].width,
                  child: Text(AdminLocalizations.translate(context, columns[i].title)),
                ),
              ),
          ],
          rows: [
            for (int i = 0; i < rows.length; i++)
              DataRow(
                selected: selected.contains(idOf(rows[i])),
                color: WidgetStatePropertyAll(i.isEven ? zebraA : zebraB),
                cells: [
                  DataCell(
                    Checkbox(
                      value: selected.contains(idOf(rows[i])),
                      onChanged: (v) => onToggleSelection(idOf(rows[i])),
                    ),
                  ),
                  for (final col in columns) DataCell(col.cell(context, rows[i])),
                ],
              ),
          ],
        );

        final totalTableWidth = columns.fold<double>(
          80.0, // Initial width for checkbox and margins
          (prev, col) => prev + (col.width ?? 150) + 18, // width + columnSpacing
        );

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: max(constraints.maxWidth, totalTableWidth),
            ),
            child: SingleChildScrollView(child: table),
          ),
        );
      },
    );
  }
}
