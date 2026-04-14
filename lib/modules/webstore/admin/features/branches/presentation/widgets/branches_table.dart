import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/branches/data/models/branch_row.dart';

class BranchesTable extends StatelessWidget {
  final List<BranchRow> items;
  final Function(BranchRow branch) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, BranchRow b)? cardBuilder;

  const BranchesTable({
    super.key,
    required this.items,
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
          cell: (_, b) => Text(b.name, maxLines: 1, overflow: TextOverflow.ellipsis),
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
          exportValue: (b) => b.isActive ? 'Yes' : 'No',
          cell: (_, b) => Text(b.isActive ? 'Yes' : 'No'),
          width: 100,
        ),
      ],
    );
  }
}
