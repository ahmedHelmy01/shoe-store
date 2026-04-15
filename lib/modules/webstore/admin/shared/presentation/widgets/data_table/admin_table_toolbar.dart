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
    const uniformPillWidth = 132.0;

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
          SizedBox(
            width: uniformPillWidth,
            child: _Pill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.table_rows_rounded, size: 18),
                  const SizedBox(width: 8),
                  PopupMenuButton<int>(
                    tooltip: 'Rows per page',
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    onSelected: onPageSize,
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 10, child: Text('Rows 10')),
                      PopupMenuItem(value: 25, child: Text('Rows 25')),
                      PopupMenuItem(value: 50, child: Text('Rows 50')),
                    ],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Rows $pageSize',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: uniformPillWidth,
            child: _Pill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download_rounded, size: 18),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    onSelected: (v) {
                      if (v == 'all') onExportAllCsv();
                      if (v == 'selected') onExportSelectedCsv?.call();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'all', child: Text('Export CSV')),
                      if (onExportSelectedCsv != null)
                        const PopupMenuItem(value: 'selected', child: Text('Export selected')),
                    ],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('CSV'),
                        SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: uniformPillWidth,
            child: _Pill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf_rounded, size: 18),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    onSelected: (v) {
                      if (v == 'all') onExportAllPdf();
                      if (v == 'selected') onExportSelectedPdf?.call();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'all', child: Text('Export PDF')),
                      if (onExportSelectedPdf != null)
                        const PopupMenuItem(value: 'selected', child: Text('Export selected')),
                    ],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('PDF'),
                        SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: uniformPillWidth,
            child: _Pill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.grid_on_rounded, size: 18),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    onSelected: (v) {
                      if (v == 'all') onExportAllExcel();
                      if (v == 'selected') onExportSelectedExcel?.call();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'all', child: Text('Export Excel')),
                      if (onExportSelectedExcel != null)
                        const PopupMenuItem(value: 'selected', child: Text('Export selected')),
                    ],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Excel'),
                        SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
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
      constraints: const BoxConstraints(minHeight: 40),
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
