import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/data/fake_data.dart';
import 'package:erp/modules/webstore/admin/presentation/models/admin_company_row.dart';

class AdminCompaniesView extends StatelessWidget {
  const AdminCompaniesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final items = FakeData.companies();

    final box = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
      ),
      child: isWide
          ? AdminDataTable<CompanyRow>(
              rows: items,
              idOf: (c) => '${c.id}',
              exportBaseName: 'companies',
              searchHint: 'Search companies…',
              searchText: (c) => '${c.id} ${c.name} ${c.country} ${c.productsCount}',
              columns: [
                AdminColumn<CompanyRow>(
                  title: 'ID',
                  sortable: true,
                  sortValue: (c) => c.id,
                  exportValue: (c) => '${c.id}',
                  cell: (_, c) => Text('${c.id}'),
                  width: 80,
                ),
                AdminColumn<CompanyRow>(
                  title: 'Name',
                  sortable: true,
                  sortValue: (c) => c.name,
                  exportValue: (c) => c.name,
                  cell: (_, c) => Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  width: 320,
                ),
                AdminColumn<CompanyRow>(
                  title: 'Country',
                  sortable: true,
                  sortValue: (c) => c.country,
                  exportValue: (c) => c.country,
                  cell: (_, c) => Text(c.country),
                  width: 120,
                ),
                AdminColumn<CompanyRow>(
                  title: 'Products',
                  sortable: true,
                  sortValue: (c) => c.productsCount,
                  exportValue: (c) => '${c.productsCount}',
                  cell: (_, c) => Text('${c.productsCount}'),
                  width: 120,
                ),
                AdminColumn<CompanyRow>(
                  title: 'Active',
                  sortable: true,
                  sortValue: (c) => c.active ? 1 : 0,
                  exportValue: (c) => c.active ? 'Yes' : 'No',
                  cell: (_, c) => Text(c.active ? 'Yes' : 'No'),
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
                final c = items[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                    child: const Icon(Icons.apartment_rounded),
                  ),
                  title: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${c.country} • Products: ${c.productsCount}'),
                  trailing: Text(c.active ? 'Active' : 'Disabled'),
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
                  'Companies',
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



