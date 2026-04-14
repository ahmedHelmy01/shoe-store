import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import '../../data/models/user_row.dart';

class UsersTable extends StatelessWidget {
  final List<UserRow> items;
  final Function(UserRow) onEdit;
  final Function(UserRow) onDelete;

  const UsersTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AdminDataTable<UserRow>(
      rows: items,
      idOf: (item) => '${item.id}',
      exportBaseName: 'customers',
      searchHint: 'Search customers...',
      searchText: (item) => '${item.name} ${item.email ?? ""} ${item.mobile ?? ""}',
      columns: [
        AdminColumn<UserRow>(
          title: 'Customer',
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
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ),
      ],
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
