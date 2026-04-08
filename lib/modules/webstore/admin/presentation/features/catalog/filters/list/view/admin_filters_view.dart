import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/presentation/common/table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/presentation/models/admin_fake_data.dart';
import 'package:erp/modules/webstore/admin/presentation/models/admin_filter_row.dart';

class AdminFiltersView extends StatelessWidget {
  const AdminFiltersView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final items = AdminFakeData.filters();

    final box = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
      ),
      child: isWide
          ? AdminDataTable<AdminFilterRow>(
              rows: items,
              idOf: (f) => '${f.id}',
              exportBaseName: 'filters',
              searchHint: 'Search filters…',
              searchText: (f) => '${f.id} ${f.name} ${f.type} ${f.optionsCount}',
              columns: [
                AdminColumn<AdminFilterRow>(
                  title: 'ID',
                  sortable: true,
                  sortValue: (f) => f.id,
                  exportValue: (f) => '${f.id}',
                  cell: (_, f) => Text('${f.id}'),
                  width: 80,
                ),
                AdminColumn<AdminFilterRow>(
                  title: 'Name',
                  sortable: true,
                  sortValue: (f) => f.name,
                  exportValue: (f) => f.name,
                  cell: (_, f) => Text(f.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  width: 320,
                ),
                AdminColumn<AdminFilterRow>(
                  title: 'Type',
                  sortable: true,
                  sortValue: (f) => f.type,
                  exportValue: (f) => f.type,
                  cell: (_, f) => Text(f.type),
                  width: 140,
                ),
                AdminColumn<AdminFilterRow>(
                  title: 'Options',
                  sortable: true,
                  sortValue: (f) => f.optionsCount,
                  exportValue: (f) => '${f.optionsCount}',
                  cell: (_, f) => Text(f.type == 'range' ? '-' : '${f.optionsCount}'),
                  width: 120,
                ),
                AdminColumn<AdminFilterRow>(
                  title: 'Active',
                  sortable: true,
                  sortValue: (f) => f.active ? 1 : 0,
                  exportValue: (f) => f.active ? 'Yes' : 'No',
                  cell: (_, f) => Text(f.active ? 'Yes' : 'No'),
                  width: 110,
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
              ),
              itemBuilder: (context, i) {
                final f = items[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                    child: const Icon(Icons.tune_rounded),
                  ),
                  title: Text(f.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('Type: ${f.type} • Options: ${f.type == 'range' ? '-' : f.optionsCount}'),
                  trailing: Text(f.active ? 'Active' : 'Disabled'),
                );
              },
            ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Filters',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: () {},
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AppAnimation.fadeInUp(
              duration: const Duration(milliseconds: 420),
              child: box,
            ),
          ),
        ],
      ),
    );
  }
}

