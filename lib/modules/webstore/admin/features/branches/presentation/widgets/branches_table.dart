import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

class BranchesTable extends StatelessWidget {
  final List<BranchRow> items;
  final Function(BranchRow branch) onView;
  final Function(BranchRow branch) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, BranchRow b)? cardBuilder;

  const BranchesTable({
    super.key,
    required this.items,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<BranchRow>(
      rows: items,
      idOf: (b) => '${b.id}',
      exportBaseName: 'branches',
      searchHint: 'Search branches…',
      searchText: (b) => '${b.id} ${b.name} ${b.nameAr ?? ''} ${b.phone ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<BranchRow>(
          title: 'ID',
          sortable: true,
          sortValue: (b) => b.id,
          exportValue: (b) => '${b.id}',
          cell: (_, b) => Text('${b.id}'),
          width: 80,
        ),
        AdminColumn<BranchRow>(
          title: 'Name',
          sortable: true,
          sortValue: (b) => b.name,
          exportValue: (b) => b.name,
          cell: (_, b) => Row(
            children: [
              Expanded(child: Text(b.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (b.isMain)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                  ),
                  child: const Text(
                    'MAIN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
            ],
          ),
          width: 240,
        ),
        AdminColumn<BranchRow>(
          title: 'Name (AR)',
          sortable: true,
          sortValue: (b) => b.nameAr ?? '',
          exportValue: (b) => b.nameAr ?? '',
          cell: (_, b) => Text(b.nameAr ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 240,
        ),
        AdminColumn<BranchRow>(
          title: 'Phone',
          sortable: true,
          sortValue: (b) => b.phone ?? '',
          exportValue: (b) => b.phone ?? '',
          cell: (_, b) => Text(b.phone ?? '-'),
          width: 160,
        ),
        AdminColumn<BranchRow>(
          title: 'Active',
          sortable: true,
          sortValue: (b) => b.isActive ? 1 : 0,
          exportValue: (b) => b.isActive ? 'Open' : 'Closed',
          cell: (_, b) => AdminStatusBadge(
            isActive: b.isActive,
            activeLabel: 'Open',
            inactiveLabel: 'Closed',
          ),
          width: 100,
        ),
        AdminColumn<BranchRow>(
          title: 'Actions',
          cell: (_, b) => AdminTableActionsCell<BranchRow>(
            row: b,
            onView: onView,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
            confirmBeforeDelete: false,
          ),
          width: 130,
        ),
      ],
    );
  }
}
