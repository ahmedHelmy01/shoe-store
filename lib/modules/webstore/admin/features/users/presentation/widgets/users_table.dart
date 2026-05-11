import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import '../../data/models/user_row.dart';

class UsersTable extends StatelessWidget {
  final List<UserRow> items;
  final Function(UserRow) onDelete;
  final Widget Function(BuildContext context, UserRow item)? cardBuilder;

  const UsersTable({
    super.key,
    required this.items,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AdminDataTable<UserRow>(
      rows: items,
      idOf: (item) => '${item.id}',
      exportBaseName: 'users',
      searchHint: 'Search users...',
      searchText: (item) => '${item.name} ${item.email ?? ""} ${item.mobile ?? ""}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<UserRow>(
          title: 'User',
          width: 280,
          cell: (_, item) => Row(
            children: [
              _UserAvatar(name: item.name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.email != null)
                      Text(
                        item.email!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AdminColumn<UserRow>(
          title: 'Mobile',
          width: 160,
          cell: (_, item) => Text(item.mobile ?? '—'),
        ),
        AdminColumn<UserRow>(
          title: 'Orders',
          width: 100,
          cell: (_, item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${item.ordersCount}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
        ),
        AdminColumn<UserRow>(
          title: 'Total Spent',
          width: 140,
          cell: (_, item) => Text(
            '${item.totalSpent.toStringAsFixed(2)} EGP',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        AdminColumn<UserRow>(
          title: 'Joined',
          width: 140,
          cell: (_, item) => Text(
            item.createdAt != null ? DateFormat('MMM dd, yyyy').format(item.createdAt!) : '—',
            style: theme.textTheme.bodySmall,
          ),
        ),
        AdminColumn<UserRow>(
          title: 'Status',
          width: 100,
          cell: (_, item) => _StatusBadge(isActive: item.isActive),
        ),
        AdminColumn<UserRow>(
          title: 'Actions',
          width: 120,
          cell: (_, item) => AdminTableActionsCell<UserRow>(
            row: item,
            onView: (row) {
              showDialog(
                context: context,
                builder: (_) => UserDetailsDialog(user: row),
              );
            },
            onDelete: onDelete,
          ),
        ),
      ],
    );
  }
}

class UserDetailsDialog extends StatelessWidget {
  final UserRow user;
  const UserDetailsDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'User Details',
      id: user.id.toString(),
      icon: Icons.person_rounded,
      children: [
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Full Name', user.name, Icons.person_outline_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Mobile', user.mobile ?? 'N/A', Icons.phone_android_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 24),
        AdminDetailsDialog.buildDetailRow(context, 'Email Address', user.email ?? 'No email provided', Icons.email_outlined),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                context,
                'Total Orders',
                '${user.ordersCount}',
                Icons.shopping_bag_outlined,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricTile(
                context,
                'Total Spent',
                '${user.totalSpent.toStringAsFixed(2)} EGP',
                Icons.account_balance_wallet_outlined,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Joined On',
                user.createdAt != null ? DateFormat('MMMM dd, yyyy').format(user.createdAt!) : 'N/A',
                Icons.calendar_today_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildStatusRow(context, user.isActive)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile(BuildContext context, String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: isDark ? 0.2 : 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String name;
  const _UserAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return CircleAvatar(
      radius: 18,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
      child: Text(
        initials,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.green : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
