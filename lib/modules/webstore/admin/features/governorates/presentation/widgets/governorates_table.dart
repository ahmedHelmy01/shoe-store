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
      searchText: (g) => '${g.id} ${g.name} ${g.nameEn ?? ''} ${g.nameAr ?? ''}',
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
          title: 'Name (EN)',
          sortable: true,
          sortValue: (g) => g.nameEn ?? g.name,
          exportValue: (g) => g.nameEn ?? g.name,
          cell: (_, g) => Text(g.nameEn ?? g.name, maxLines: 1, overflow: TextOverflow.ellipsis),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Name (EN)',
                gov.nameEn ?? gov.name,
                Icons.title_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Name (AR)',
                gov.nameAr ?? 'N/A',
                Icons.translate_rounded,
                bottomPadding: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Country',
                gov.countryName ?? 'N/A',
                Icons.public_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Container()),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildStatusRow(context, gov.isActive),
      ],
    );
  }
}
