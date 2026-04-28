import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

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
      searchText: (c) => '${c.id} ${c.name} ${c.nameAr ?? ''}',
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
          title: 'Arabic Name',
          sortable: true,
          sortValue: (c) => c.nameAr ?? '',
          exportValue: (c) => c.nameAr ?? '',
          cell: (_, c) => Text(c.nameAr ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 200,
        ),
        AdminColumn<CompanyRow>(
          title: 'Status',
          sortable: true,
          sortValue: (c) => c.isActive ? 1 : 0,
          exportValue: (c) => c.isActive ? 'Active' : 'Inactive',
          cell: (_, c) => AdminStatusBadge(isActive: c.isActive),
          width: 100,
        ),
        AdminColumn<CompanyRow>(
          title: 'Actions',
          cell: (_, c) => AdminTableActionsCell<CompanyRow>(
            row: c,
            onView: (c) {
              showDialog(
                context: context,
                builder: (context) => AdminDetailsDialog(
                  title: 'Company Details',
                  id: c.id.toString(),
                  icon: Icons.business_rounded,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (EN)', c.name, Icons.language_rounded, bottomPadding: 0)),
                        const SizedBox(width: 16),
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (AR)', c.nameAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AdminDetailsDialog.buildStatusRow(context, c.isActive),
                  ],
                ),
              );
            },
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

