import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/presentation/common/table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/presentation/models/admin_fake_data.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final items = AdminFakeData.users();

    final box = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
      ),
      child: isWide
          ? AdminDataTable<WebStoreUser>(
              rows: items,
              idOf: (u) => '${u.id}',
              exportBaseName: 'users',
              searchHint: 'Search users…',
              searchText: (u) => '${u.id} ${u.name} ${u.email ?? ''} ${u.mobile ?? ''}',
              columns: [
                AdminColumn<WebStoreUser>(
                  title: 'ID',
                  sortable: true,
                  sortValue: (u) => u.id,
                  exportValue: (u) => '${u.id}',
                  cell: (_, u) => Text('${u.id}'),
                  width: 80,
                ),
                AdminColumn<WebStoreUser>(
                  title: 'Name',
                  sortable: true,
                  sortValue: (u) => u.name,
                  exportValue: (u) => u.name,
                  cell: (_, u) => Text(u.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  width: 260,
                ),
                AdminColumn<WebStoreUser>(
                  title: 'Email',
                  sortable: true,
                  sortValue: (u) => u.email ?? '',
                  exportValue: (u) => u.email ?? '',
                  cell: (_, u) => Text(u.email ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
                  width: 260,
                ),
                AdminColumn<WebStoreUser>(
                  title: 'Mobile',
                  sortable: true,
                  sortValue: (u) => u.mobile ?? '',
                  exportValue: (u) => u.mobile ?? '',
                  cell: (_, u) => Text(u.mobile ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
                  width: 200,
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
                final u = items[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                    child: const Icon(Icons.person_rounded),
                  ),
                  title: Text(u.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${u.email ?? '-'} • ${u.mobile ?? '-'}'),
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
                  'Users',
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

