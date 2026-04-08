import 'dart:math';

import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/presentation/common/export/admin_export.dart';
import 'package:excel/excel.dart' as ex;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

typedef AdminIdOf<T> = String Function(T row);
typedef AdminCellText<T> = String Function(T row);

class AdminColumn<T> {
  final String title;
  final double? width;
  final bool sortable;
  final Comparable? Function(T row)? sortValue;
  final String Function(T row)? exportValue;
  final Widget Function(BuildContext context, T row) cell;

  const AdminColumn({
    required this.title,
    required this.cell,
    this.width,
    this.sortable = false,
    this.sortValue,
    this.exportValue,
  });
}

class AdminDataTable<T> extends StatefulWidget {
  final List<T> rows;
  final AdminIdOf<T> idOf;
  final List<AdminColumn<T>> columns;
  final String exportBaseName;
  final bool enableSearch;
  final String searchHint;
  final String Function(T row)? searchText;

  const AdminDataTable({
    super.key,
    required this.rows,
    required this.idOf,
    required this.columns,
    required this.exportBaseName,
    this.enableSearch = true,
    this.searchHint = 'Search…',
    this.searchText,
  });

  @override
  State<AdminDataTable<T>> createState() => _AdminDataTableState<T>();
}

class _AdminDataTableState<T> extends State<AdminDataTable<T>> {
  final Set<String> _selected = <String>{};
  int? _sortIndex;
  bool _sortAsc = true;
  int _pageSize = 10;
  int _page = 1;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<T> get _filtered {
    if (!widget.enableSearch) return widget.rows.toList(growable: false);
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.rows.toList(growable: false);

    final searchText = widget.searchText ?? _defaultSearchText;
    return widget.rows
        .where((r) => searchText(r).toLowerCase().contains(q))
        .toList(growable: false);
  }

  String _defaultSearchText(T row) {
    final parts = <String>[];
    for (final c in widget.columns) {
      final v = c.exportValue?.call(row) ?? c.sortValue?.call(row)?.toString();
      if (v != null && v.trim().isNotEmpty) parts.add(v);
    }
    return parts.join(' ');
  }

  List<T> get _sorted {
    final list = _filtered;
    if (_sortIndex == null) return list;
    final col = widget.columns[_sortIndex!];
    final key = col.sortValue;
    if (key == null) return list;

    final copy = list.toList();
    copy.sort((a, b) {
      final va = key(a);
      final vb = key(b);
      final cmp = _cmpNullable(va, vb);
      return _sortAsc ? cmp : -cmp;
    });
    return copy;
  }

  int get _pageCount => max(1, (_sorted.length / _pageSize).ceil());

  List<T> get _pageRows {
    final start = (_page - 1) * _pageSize;
    final end = min(start + _pageSize, _sorted.length);
    if (start >= _sorted.length) return const [];
    return _sorted.sublist(start, end);
  }

  @override
  void didUpdateWidget(covariant AdminDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _page = min(_page, _pageCount);
    // Drop selections that no longer exist
    final ids = widget.rows.map(widget.idOf).toSet();
    _selected.removeWhere((id) => !ids.contains(id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);

    final pageRows = _pageRows;
    final allOnPageSelected = pageRows.isNotEmpty &&
        pageRows.every((r) => _selected.contains(widget.idOf(r)));

    return Column(
      children: [
        _Toolbar(
          selectedCount: _selected.length,
          enableSearch: widget.enableSearch,
          searchHint: widget.searchHint,
          searchController: _searchCtrl,
          onSearchChanged: (v) => setState(() {
            _query = v;
            _page = 1;
          }),
          pageSize: _pageSize,
          onPageSize: (v) => setState(() {
            _pageSize = v;
            _page = 1;
          }),
          onExportAllCsv: () => _exportCsv(rows: _sorted, filenameSuffix: 'all'),
          onExportSelectedCsv: _selected.isEmpty
              ? null
              : () {
                  final map = {for (final r in widget.rows) widget.idOf(r): r};
                  final selectedRows = _selected.map((id) => map[id]).whereType<T>().toList();
                  _exportCsv(rows: selectedRows, filenameSuffix: 'selected');
                },
          onExportAllPdf: () => _exportPdf(rows: _sorted, filenameSuffix: 'all'),
          onExportSelectedPdf: _selected.isEmpty
              ? null
              : () {
                  final map = {for (final r in widget.rows) widget.idOf(r): r};
                  final selectedRows = _selected.map((id) => map[id]).whereType<T>().toList();
                  _exportPdf(rows: selectedRows, filenameSuffix: 'selected');
                },
          onExportAllExcel: () => _exportExcel(rows: _sorted, filenameSuffix: 'all'),
          onExportSelectedExcel: _selected.isEmpty
              ? null
              : () {
                  final map = {for (final r in widget.rows) widget.idOf(r): r};
                  final selectedRows = _selected.map((id) => map[id]).whereType<T>().toList();
                  _exportExcel(rows: selectedRows, filenameSuffix: 'selected');
                },
          onClearSelection: _selected.isEmpty ? null : () => setState(_selected.clear),
        ),
        Divider(height: 1, thickness: 1, color: border),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final zebraA = (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.03 : 0.03);
              final zebraB = (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.015 : 0.015);

              final table = DataTable(
                headingRowColor: WidgetStatePropertyAll(
                  (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                ),
                // We manage selection ourselves (avoid the built-in checkbox column).
                showCheckboxColumn: false,
                horizontalMargin: 16,
                columnSpacing: 18,
                headingRowHeight: 54,
                dataRowMinHeight: 52,
                dataRowMaxHeight: 64,
                sortAscending: _sortAsc,
                sortColumnIndex: _sortIndex == null ? null : _sortIndex! + 1, // +1 because selection column
                columns: [
                  DataColumn(
                    label: Checkbox(
                      value: allOnPageSelected,
                      onChanged: (v) {
                        setState(() {
                          final shouldSelect = v ?? false;
                          for (final r in pageRows) {
                            final id = widget.idOf(r);
                            if (shouldSelect) {
                              _selected.add(id);
                            } else {
                              _selected.remove(id);
                            }
                          }
                        });
                      },
                    ),
                  ),
                  for (int i = 0; i < widget.columns.length; i++)
                    DataColumn(
                      onSort: widget.columns[i].sortable
                          ? (_, asc) {
                              setState(() {
                                _sortIndex = i;
                                _sortAsc = asc;
                              });
                            }
                          : null,
                      label: SizedBox(
                        width: widget.columns[i].width,
                        child: Text(widget.columns[i].title),
                      ),
                    ),
                ],
                rows: [
                  for (int i = 0; i < pageRows.length; i++)
                    DataRow(
                      selected: _selected.contains(widget.idOf(pageRows[i])),
                      color: WidgetStatePropertyAll(i.isEven ? zebraA : zebraB),
                      cells: [
                        DataCell(
                          Checkbox(
                            value: _selected.contains(widget.idOf(pageRows[i])),
                            onChanged: (v) {
                              final id = widget.idOf(pageRows[i]);
                              setState(() {
                                if (v ?? false) {
                                  _selected.add(id);
                                } else {
                                  _selected.remove(id);
                                }
                              });
                            },
                          ),
                        ),
                        for (final col in widget.columns) DataCell(col.cell(context, pageRows[i])),
                      ],
                    ),
                ],
              );

              // Make the table fill the available width (symmetry on wide screens),
              // while still allowing horizontal scroll if columns exceed space.
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: SingleChildScrollView(
                    child: table,
                  ),
                ),
              );
            },
          ),
        ),
        Divider(height: 1, thickness: 1, color: border),
        _TableFooter(
          page: _page,
          pageCount: _pageCount,
          pageSize: _pageSize,
          total: _sorted.length,
          onPrev: _page > 1 ? () => setState(() => _page--) : null,
          onNext: _page < _pageCount ? () => setState(() => _page++) : null,
        ),
      ],
    );
  }

  Future<void> _exportCsv({required List<T> rows, required String filenameSuffix}) async {
    final cols = widget.columns;

    String esc(String v) {
      final needs = v.contains(',') || v.contains('"') || v.contains('\n') || v.contains('\r');
      final out = v.replaceAll('"', '""');
      return needs ? '"$out"' : out;
    }

    final header = cols.map((c) => esc(c.title)).join(',');
    final lines = <String>[header];

    for (final r in rows) {
      final values = cols.map((c) {
        final v = c.exportValue?.call(r) ?? c.sortValue?.call(r)?.toString() ?? '';
        return esc(v);
      }).join(',');
      lines.add(values);
    }

    final csv = lines.join('\n');
    final filename = '${widget.exportBaseName}_$filenameSuffix.csv';
    await AdminExport.downloadText(filename: filename, content: csv, mimeType: 'text/csv;charset=utf-8');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Exported $filenameSuffix (${rows.length})',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
  }

  Future<void> _exportExcel({required List<T> rows, required String filenameSuffix}) async {
    final cols = widget.columns;
    final excel = ex.Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow(cols.map((c) => ex.TextCellValue(c.title)).toList());
    for (final r in rows) {
      sheet.appendRow(
        cols
            .map((c) => ex.TextCellValue(c.exportValue?.call(r) ?? c.sortValue?.call(r)?.toString() ?? ''))
            .toList(),
      );
    }

    final bytes = excel.save();
    if (bytes == null) return;

    final filename = '${widget.exportBaseName}_$filenameSuffix.xlsx';
    await AdminExport.downloadBytes(
      filename: filename,
      bytes: bytes,
      mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Exported $filenameSuffix (${rows.length})',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
  }

  Future<void> _exportPdf({required List<T> rows, required String filenameSuffix}) async {
    final cols = widget.columns;
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Text(
              '${widget.exportBaseName.toUpperCase()} (${rows.length})',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            pw.TableHelper.fromTextArray(
              headers: cols.map((c) => c.title).toList(),
              data: rows
                  .map((r) => cols.map((c) => c.exportValue?.call(r) ?? c.sortValue?.call(r)?.toString() ?? '').toList())
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    final bytes = await doc.save();
    final filename = '${widget.exportBaseName}_$filenameSuffix.pdf';
    await AdminExport.downloadBytes(filename: filename, bytes: bytes, mimeType: 'application/pdf');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Exported $filenameSuffix (${rows.length})',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
  }
}

class _Toolbar extends StatelessWidget {
  final int selectedCount;
  final int pageSize;
  final ValueChanged<int> onPageSize;
  final bool enableSearch;
  final String searchHint;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onExportAllCsv;
  final VoidCallback? onExportSelectedCsv;
  final VoidCallback onExportAllPdf;
  final VoidCallback? onExportSelectedPdf;
  final VoidCallback onExportAllExcel;
  final VoidCallback? onExportSelectedExcel;
  final VoidCallback? onClearSelection;

  const _Toolbar({
    required this.selectedCount,
    required this.pageSize,
    required this.onPageSize,
    required this.enableSearch,
    required this.searchHint,
    required this.searchController,
    required this.onSearchChanged,
    required this.onExportAllCsv,
    required this.onExportSelectedCsv,
    required this.onExportAllPdf,
    required this.onExportSelectedPdf,
    required this.onExportAllExcel,
    required this.onExportSelectedExcel,
    required this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          if (enableSearch)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: searchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  isDense: true,
                  filled: true,
                  fillColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: border),
                  ),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear',
                          onPressed: () {
                            searchController.clear();
                            onSearchChanged('');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
            ),
          if (selectedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: AppColors.primaryOrange.withValues(alpha: 0.14),
                border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.25)),
              ),
              child: Text(
                '$selectedCount selected',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
          if (selectedCount > 0)
            TextButton(
              onPressed: onClearSelection,
              child: const Text('Clear'),
            ),
          const SizedBox(width: 6),
          _Pill(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.table_rows_rounded, size: 18),
                const SizedBox(width: 8),
                const Text('Rows'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: pageSize,
                  underline: const SizedBox.shrink(),
                  onChanged: (v) => v == null ? null : onPageSize(v),
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('10')),
                    DropdownMenuItem(value: 25, child: Text('25')),
                    DropdownMenuItem(value: 50, child: Text('50')),
                  ],
                ),
              ],
            ),
          ),
          _Pill(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.download_rounded, size: 18),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onExportAllCsv,
                  child: const Text('Export CSV'),
                ),
                if (onExportSelectedCsv != null) ...[
                  Container(width: 1, height: 18, color: border),
                  TextButton(
                    onPressed: onExportSelectedCsv,
                    child: const Text('Export selected'),
                  ),
                ],
              ],
            ),
          ),
          _Pill(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.picture_as_pdf_rounded, size: 18),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onExportAllPdf,
                  child: const Text('Export PDF'),
                ),
                if (onExportSelectedPdf != null) ...[
                  Container(width: 1, height: 18, color: border),
                  TextButton(
                    onPressed: onExportSelectedPdf,
                    child: const Text('Selected'),
                  ),
                ],
              ],
            ),
          ),
          _Pill(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.grid_on_rounded, size: 18),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onExportAllExcel,
                  child: const Text('Export Excel'),
                ),
                if (onExportSelectedExcel != null) ...[
                  Container(width: 1, height: 18, color: border),
                  TextButton(
                    onPressed: onExportSelectedExcel,
                    child: const Text('Selected'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TableFooter extends StatelessWidget {
  final int page;
  final int pageCount;
  final int pageSize;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _TableFooter({
    required this.page,
    required this.pageCount,
    required this.pageSize,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final muted = (theme.textTheme.bodySmall?.color ?? (isDark ? Colors.white : Colors.black)).withValues(alpha: 0.72);

    final start = total == 0 ? 0 : ((page - 1) * pageSize) + 1;
    final end = min(page * pageSize, total);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Text(
            total == 0 ? 'No rows' : 'Showing $start–$end of $total',
            style: theme.textTheme.bodySmall?.copyWith(color: muted, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Prev',
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Text(
            'Page $page / $pageCount',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          IconButton(
            tooltip: 'Next',
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final Widget child;
  const _Pill({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700) ?? const TextStyle(),
        child: child,
      ),
    );
  }
}

int _cmpNullable(Comparable? a, Comparable? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}

