import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

class AdminDataTableToolbar extends StatelessWidget {
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

  const AdminDataTableToolbar({
    super.key,
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
