import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';
import 'package:erp/modules/webstore/admin/shared/export/admin_export.dart';
import 'package:excel/excel.dart' as ex;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// New modular imports
import 'data_table/admin_table_models.dart';
import 'data_table/admin_table_toolbar.dart';
import 'data_table/admin_table_footer.dart';
import 'data_table/admin_table_actions_cell.dart';

export 'data_table/admin_table_models.dart';
export 'data_table/admin_table_actions_cell.dart';

class AdminDataTable<T> extends StatefulWidget {
  final List<T> rows;
  final AdminIdOf<T> idOf;
  final List<AdminColumn<T>> columns;
  final String exportBaseName;
  final bool enableSearch;
  final String searchHint;
  final String Function(T row)? searchText;
  final Widget Function(BuildContext context, T row)? cardBuilder;
  final double borderRadius;

  final bool isServerSide;
  final int serverPage;
  final int serverLastPage;
  final int serverTotal;
  final VoidCallback? onNextPage;
  final VoidCallback? onPrevPage;
  final ValueChanged<String>? onSearch;
  final String? initialSearchQuery;
  final int? initialPageSize;
  final ValueChanged<int>? onServerPageSize;

  const AdminDataTable({
    super.key,
    required this.rows,
    required this.idOf,
    required this.columns,
    required this.exportBaseName,
    this.enableSearch = true,
    this.searchHint = 'Search…',
    this.searchText,
    this.cardBuilder,
    this.borderRadius = 18,
    this.isServerSide = false,
    this.serverPage = 1,
    this.serverLastPage = 1,
    this.serverTotal = 0,
    this.onNextPage,
    this.onPrevPage,
    this.onSearch,
    this.initialSearchQuery,
    this.initialPageSize,
    this.onServerPageSize,
  });

  @override
  State<AdminDataTable<T>> createState() => _AdminDataTableState<T>();
}

class _AdminDataTableState<T> extends State<AdminDataTable<T>> {
  final Set<String> _selected = <String>{};
  int? _sortIndex;
  bool _sortAsc = true;
  late int _pageSize;
  int _page = 1;
  late final TextEditingController _searchCtrl;
  late String _query;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pageSize = widget.initialPageSize ?? 10;
    _query = widget.initialSearchQuery ?? '';
    _searchCtrl = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  List<T> get _filtered {
    if (widget.isServerSide) return widget.rows.toList(growable: false);
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

  int get _pageCount => widget.isServerSide ? widget.serverLastPage : max(1, (_sorted.length / _pageSize).ceil());

  List<T> get _pageRows {
    if (widget.isServerSide) return _sorted;
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
    final isEmptyState = _sorted.isEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        color: isDark ? const Color(0xFF0F1B2D) : Colors.white,
        child: Column(
        children: [
        AdminDataTableToolbar(
          selectedCount: _selected.length,
          enableSearch: widget.enableSearch,
          searchHint: widget.searchHint,
          searchController: _searchCtrl,
          onSearchChanged: (v) {
            setState(() {
              _query = v;
              if (!widget.isServerSide) _page = 1;
            });
          },
          onSearchSubmitted: (v) {
            if (widget.isServerSide && widget.onSearch != null) {
              widget.onSearch!(v);
            }
          },
          pageSize: _pageSize,
          onPageSize: (v) {
            setState(() {
              _pageSize = v;
              _page = 1;
            });
            if (widget.isServerSide) {
              widget.onServerPageSize?.call(v);
            }
          },
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
        if (isEmptyState)
          const Expanded(
            child: AppEmptyWidget(
              message: 'No data found',
              subtitle: 'There are no records to display yet.',
              showGlassBackground: false,
            ),
          )
        else
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                if (isMobile && widget.cardBuilder != null) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: pageRows.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => widget.cardBuilder!(context, pageRows[i]),
                  );
                }

              final zebraA = (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.03 : 0.03);
              final zebraB = (isDark ? Colors.white : Colors.black).withValues(alpha: isDark ? 0.015 : 0.015);

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
                sortAscending: _sortAsc,
                sortColumnIndex: _sortIndex == null ? null : _sortIndex! + 1,
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
        AdminDataTableFooter(
          page: widget.isServerSide ? widget.serverPage : _page,
          pageCount: widget.isServerSide ? widget.serverLastPage : _pageCount,
          pageSize: widget.isServerSide ? widget.rows.length : _pageSize,
          total: widget.isServerSide ? widget.serverTotal : _sorted.length,
          onPrev: widget.isServerSide 
              ? widget.onPrevPage 
              : (_page > 1 ? () => setState(() => _page--) : null),
          onNext: widget.isServerSide 
              ? widget.onNextPage 
              : (_page < _pageCount ? () => setState(() => _page++) : null),
        ),
        ],
      ),
      ),
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

int _cmpNullable(Comparable? a, Comparable? b) {
  if (a == null && b == null) return 0;
  if (a == null) return 1;
  if (b == null) return -1;
  return a.compareTo(b);
}
