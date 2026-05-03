import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_empty_widget/app_empty_widget.dart';

// Modular imports
import 'widgets/admin_table_models.dart';
import 'widgets/admin_table_toolbar.dart';
import 'widgets/admin_table_footer.dart';
import 'widgets/admin_table_content.dart';
import 'widgets/admin_table_exporter.dart';

export 'widgets/admin_table_models.dart';
export 'widgets/admin_table_actions_cell.dart';

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

  int get _pageCount => widget.isServerSide
      ? widget.serverLastPage
      : max(1, (_sorted.length / _pageSize).ceil());

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
    final ids = widget.rows.map(widget.idOf).toSet();
    _selected.removeWhere((id) => !ids.contains(id));
  }

  void _export(String type, List<T> rows, String suffix) {
    switch (type) {
      case 'csv':
        AdminTableExporter.exportCsv(
          context: context,
          rows: rows,
          columns: widget.columns,
          baseName: widget.exportBaseName,
          suffix: suffix,
        );
        break;
      case 'excel':
        AdminTableExporter.exportExcel(
          context: context,
          rows: rows,
          columns: widget.columns,
          baseName: widget.exportBaseName,
          suffix: suffix,
        );
        break;
      case 'pdf':
        AdminTableExporter.exportPdf(
          context: context,
          rows: rows,
          columns: widget.columns,
          baseName: widget.exportBaseName,
          suffix: suffix,
        );
        break;
    }
  }

  List<T> _getSelectedRows() {
    final map = {for (final r in widget.rows) widget.idOf(r): r};
    return _selected.map((id) => map[id]).whereType<T>().toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);

    final pageRows = _pageRows;
    final allOnPageSelected = pageRows.isNotEmpty && pageRows.every((r) => _selected.contains(widget.idOf(r)));
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
              onSearchChanged: (v) => setState(() {
                _query = v;
                if (!widget.isServerSide) _page = 1;
              }),
              onSearchSubmitted: (v) {
                if (widget.isServerSide && widget.onSearch != null) widget.onSearch!(v);
              },
              pageSize: _pageSize,
              onPageSize: (v) {
                setState(() {
                  _pageSize = v;
                  _page = 1;
                });
                if (widget.isServerSide) widget.onServerPageSize?.call(v);
              },
              onExportAllCsv: () => _export('csv', _sorted, 'all'),
              onExportSelectedCsv: _selected.isEmpty ? null : () => _export('csv', _getSelectedRows(), 'selected'),
              onExportAllPdf: () => _export('pdf', _sorted, 'all'),
              onExportSelectedPdf: _selected.isEmpty ? null : () => _export('pdf', _getSelectedRows(), 'selected'),
              onExportAllExcel: () => _export('excel', _sorted, 'all'),
              onExportSelectedExcel: _selected.isEmpty ? null : () => _export('excel', _getSelectedRows(), 'selected'),
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
                child: AdminTableContent<T>(
                  rows: pageRows,
                  columns: widget.columns,
                  idOf: widget.idOf,
                  selected: _selected,
                  allOnPageSelected: allOnPageSelected,
                  sortIndex: _sortIndex,
                  sortAsc: _sortAsc,
                  cardBuilder: widget.cardBuilder,
                  onSort: (idx, asc) => setState(() {
                    _sortIndex = idx;
                    _sortAsc = asc;
                  }),
                  onToggleSelection: (id) => setState(() {
                    if (!_selected.remove(id)) _selected.add(id);
                  }),
                  onToggleAll: (v) => setState(() {
                    final shouldSelect = v ?? false;
                    for (final r in pageRows) {
                      final id = widget.idOf(r);
                      if (shouldSelect) {
                        _selected.add(id);
                      } else {
                        _selected.remove(id);
                      }
                    }
                  }),
                ),
              ),
            Divider(height: 1, thickness: 1, color: border),
            AdminDataTableFooter(
              page: widget.isServerSide ? widget.serverPage : _page,
              pageCount: widget.isServerSide ? widget.serverLastPage : _pageCount,
              pageSize: widget.isServerSide ? widget.rows.length : _pageSize,
              total: widget.isServerSide ? widget.serverTotal : _sorted.length,
              onPrev: widget.isServerSide ? widget.onPrevPage : (_page > 1 ? () => setState(() => _page--) : null),
              onNext: widget.isServerSide ? widget.onNextPage : (_page < _pageCount ? () => setState(() => _page++) : null),
            ),
          ],
        ),
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
