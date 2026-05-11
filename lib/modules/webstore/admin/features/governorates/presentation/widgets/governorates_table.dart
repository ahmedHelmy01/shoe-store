import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

class GovernoratesTable extends StatelessWidget {
  final List<GovernorateRow> items;
  final Function(GovernorateRow g) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, GovernorateRow g)? cardBuilder;

  const GovernoratesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<GovernorateRow>(
      rows: items,
      idOf: (g) => '${g.id}',
      exportBaseName: 'governorates',
      searchHint: 'Search governorates…',
      searchText: (g) => '${g.id} ${g.name} ${g.nameAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<GovernorateRow>(
          title: 'ID',
          sortable: true,
          sortValue: (g) => g.id,
          exportValue: (g) => '${g.id}',
          cell: (_, g) => Text('${g.id}'),
          width: 80,
        ),
        AdminColumn<GovernorateRow>(
          title: 'Name',
          sortable: true,
          sortValue: (g) => g.name,
          exportValue: (g) => g.name,
          cell: (_, g) => Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<GovernorateRow>(
          title: 'Name (AR)',
          sortable: true,
          sortValue: (g) => g.nameAr ?? '',
          exportValue: (g) => g.nameAr ?? '',
          cell: (_, g) => Text(g.nameAr ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<GovernorateRow>(
          title: 'Active',
          sortable: true,
          sortValue: (g) => g.isActive ? 1 : 0,
          exportValue: (g) => g.isActive ? 'Yes' : 'No',
          cell: (_, g) => AdminStatusBadge(isActive: g.isActive),
          width: 120,
        ),
        AdminColumn<GovernorateRow>(
          title: 'Actions',
          cell: (_, g) => AdminTableActionsCell<GovernorateRow>(
            row: g,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
            onView: (it) {
              showDialog(
                context: context,
                builder: (_) => GovernorateDetailsDialog(gov: it),
              );
            },
          ),
          width: 130,
        ),
      ],
    );
  }
}

class GovernorateDetailsDialog extends StatelessWidget {
  final GovernorateRow gov;
  const GovernorateDetailsDialog({super.key, required this.gov});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'Governorate Details',
      id: gov.id.toString(),
      icon: Icons.map_rounded,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                gov.nameAr ?? gov.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                gov.name,
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Country',
                gov.countryName ?? 'N/A',
                Icons.public_rounded,
              ),
            ),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Status',
                gov.isActive ? 'Active' : 'Inactive',
                gov.isActive ? Icons.check_circle_outline : Icons.error_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AdminDetailsDialog.buildStatusRow(context, gov.isActive),
      ],
    );
  }
}
