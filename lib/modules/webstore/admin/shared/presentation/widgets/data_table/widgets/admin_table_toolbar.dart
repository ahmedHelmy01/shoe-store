import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
    this.onSearchSubmitted,
    required this.onExportAllCsv,
    required this.onExportSelectedCsv,
    required this.onExportAllPdf,
    required this.onExportSelectedPdf,
    required this.onExportAllExcel,
    required this.onExportSelectedExcel,
    required this.onClearSelection,
  });

  final ValueChanged<String>? onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final border = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08);
    const uniformPillWidth = 132.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final isMobile = constraints.maxWidth < 500;
        
        // Calculate width for export buttons to be 2 per row on mobile
        // 24 is the total horizontal padding (12 on each side)
        // 10 is the spacing between pills
        final pillWidth = isMobile 
            ? (constraints.maxWidth - 24 - 10) / 2 
            : uniformPillWidth;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Wrap(
            alignment: isWide ? WrapAlignment.spaceBetween : WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              if (enableSearch)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 360 : double.infinity),
                  child: TextField(
                    controller: searchController,
                    onChanged: (v) {
                      onSearchChanged(v);
                      if (v.isEmpty) {
                        onSearchSubmitted?.call('');
                      }
                    },
                    onSubmitted: onSearchSubmitted,
                    decoration: InputDecoration(
                      hintText: AdminLocalizations.translate(context, searchHint),
                      prefixIcon: IconButton(
                        tooltip: AdminLocalizations.translate(context, 'Search'),
                        icon: const Icon(Icons.search_rounded),
                        onPressed: () => onSearchSubmitted?.call(searchController.text),
                      ),
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
                              tooltip: AdminLocalizations.translate(context, 'Clear'),
                              onPressed: () {
                                searchController.clear();
                                onSearchChanged('');
                                onSearchSubmitted?.call('');
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                    ),
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (selectedCount > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: AppColors.primaryOrange.withValues(alpha: 0.14),
                        border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        '$selectedCount ${AdminLocalizations.translate(context, 'selected')}',
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    TextButton(
                      onPressed: onClearSelection,
                      child: Text(AdminLocalizations.translate(context, 'Clear')),
                    ),
                  ],
                  SizedBox(
                    width: pillWidth,
                    child: _Pill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.table_rows_rounded, size: 18),
                          const SizedBox(width: 8),
                          PopupMenuButton<int>(
                            tooltip: AdminLocalizations.translate(context, 'Rows per page'),
                            padding: EdgeInsets.zero,
                            color: isDark ? const Color(0xFF1E2A3A) : Colors.white,
                            surfaceTintColor: isDark ? const Color(0xFF1E2A3A) : Colors.white,
                            onSelected: onPageSize,
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 10, child: Text('${AdminLocalizations.translate(context, 'Rows')} 10')),
                              PopupMenuItem(value: 25, child: Text('${AdminLocalizations.translate(context, 'Rows')} 25')),
                              PopupMenuItem(value: 50, child: Text('${AdminLocalizations.translate(context, 'Rows')} 50')),
                            ],
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${AdminLocalizations.translate(context, 'Rows')} $pageSize',
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
                    width: pillWidth,
                    child: _Pill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.download_rounded, size: 18),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            color: isDark ? const Color(0xFF1E2A3A) : Colors.white,
                            surfaceTintColor: isDark ? const Color(0xFF1E2A3A) : Colors.white,
                            onSelected: (v) {
                              if (v == 'all') onExportAllCsv();
                              if (v == 'selected') onExportSelectedCsv?.call();
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 'all', child: Text(AdminLocalizations.translate(context, 'Export CSV'))),
                              if (onExportSelectedCsv != null)
                                PopupMenuItem(value: 'selected', child: Text(AdminLocalizations.translate(context, 'Export selected'))),
                            ],
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AdminLocalizations.translate(context, 'CSV')),
                                const SizedBox(width: 2),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: pillWidth,
                    child: _Pill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.picture_as_pdf_rounded, size: 18),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            color: isDark ? const Color(0xFF1E2A3A) : Colors.white,
                            surfaceTintColor: isDark ? const Color(0xFF1E2A3A) : Colors.white,
                            onSelected: (v) {
                              if (v == 'all') onExportAllPdf();
                              if (v == 'selected') onExportSelectedPdf?.call();
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 'all', child: Text(AdminLocalizations.translate(context, 'Export PDF'))),
                              if (onExportSelectedPdf != null)
                                PopupMenuItem(value: 'selected', child: Text(AdminLocalizations.translate(context, 'Export selected'))),
                            ],
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AdminLocalizations.translate(context, 'PDF')),
                                const SizedBox(width: 2),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: pillWidth,
                    child: _Pill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.grid_on_rounded, size: 18),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            color: isDark ? const Color(0xFF1E2A3A) : Colors.white,
                            surfaceTintColor: isDark ? const Color(0xFF1E2A3A) : Colors.white,
                            onSelected: (v) {
                              if (v == 'all') onExportAllExcel();
                              if (v == 'selected') onExportSelectedExcel?.call();
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 'all', child: Text(AdminLocalizations.translate(context, 'Export Excel'))),
                              if (onExportSelectedExcel != null)
                                PopupMenuItem(value: 'selected', child: Text(AdminLocalizations.translate(context, 'Export selected'))),
                            ],
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(AdminLocalizations.translate(context, 'Excel')),
                                const SizedBox(width: 2),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
