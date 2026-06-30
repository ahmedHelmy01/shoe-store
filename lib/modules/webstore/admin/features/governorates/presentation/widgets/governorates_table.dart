import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/governorates/data/models/governorate_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
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
      searchHint: AdminLocalizations.translate(context, 'search governorates…'),
      searchText: (g) => '${g.id} ${g.name} ${g.nameEn ?? ''} ${g.nameAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<GovernorateRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (g) => g.id,
          exportValue: (g) => '${g.id}',
          cell: (_, g) => Text('${g.id}'),
          width: 80,
        ),
        AdminColumn<GovernorateRow>(
          title: AdminLocalizations.translate(context, 'name (en)'),
          sortable: true,
          sortValue: (g) => g.nameEn ?? g.name,
          exportValue: (g) => g.nameEn ?? g.name,
          cell: (_, g) => Text(g.nameEn ?? g.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<GovernorateRow>(
          title: AdminLocalizations.translate(context, 'name (ar)'),
          sortable: true,
          sortValue: (g) => g.nameAr ?? '',
          exportValue: (g) => g.nameAr ?? '',
          cell: (_, g) => Text(g.nameAr ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<GovernorateRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (g) => g.isActive ? 1 : 0,
          exportValue: (g) => g.isActive ? AdminLocalizations.translate(context, 'yes') : AdminLocalizations.translate(context, 'no'),
          cell: (_, g) => AdminStatusBadge(isActive: g.isActive),
          width: 120,
        ),
        AdminColumn<GovernorateRow>(
          title: AdminLocalizations.translate(context, 'actions'),
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
      title: AdminLocalizations.translate(context, 'governorate details'),
      id: gov.id.toString(),
      icon: Icons.map_rounded,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'name (en)'),
                gov.nameEn ?? gov.name,
                Icons.title_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'name (ar)'),
                gov.nameAr ?? AdminLocalizations.translate(context, 'n/a'),
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
                AdminLocalizations.translate(context, 'country'),
                gov.countryName ?? AdminLocalizations.translate(context, 'n/a'),
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
