import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';

class CompaniesTable extends StatelessWidget {
  final List<CompanyRow> items;
  final Function(CompanyRow company) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, CompanyRow c)? cardBuilder;

  const CompaniesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CompanyRow>(
      rows: items,
      idOf: (c) => '${c.id}',
      exportBaseName: 'companies',
      searchHint: 'Search companies…',
      searchText: (c) => '${c.id} ${c.name} ${c.code ?? ''}',
      cardBuilder: cardBuilder,
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
          cell: (_, c) => Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 250,
        ),
        AdminColumn<CompanyRow>(
          title: 'Code',
          sortable: true,
          sortValue: (c) => c.code ?? '',
          exportValue: (c) => c.code ?? '',
          cell: (_, c) => Text(c.code ?? '-'),
          width: 120,
        ),
        AdminColumn<CompanyRow>(
          title: 'Status',
          sortable: true,
          sortValue: (c) => c.isActive ? 1 : 0,
          exportValue: (c) => c.isActive ? 'Active' : 'Inactive',
          cell: (_, c) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (c.isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              c.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: c.isActive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          width: 100,
        ),
        AdminColumn<CompanyRow>(
          title: 'Actions',
          cell: (_, c) => AdminTableActionsCell<CompanyRow>(
            row: c,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
          ),
          width: 130,
        ),
      ],
    );
  }
}
