import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/models/boarding_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class BoardingsTable extends StatelessWidget {
  final List<BoardingRow> items;
  final Function(BoardingRow boarding) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, BoardingRow b)? cardBuilder;

  const BoardingsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<BoardingRow>(
      rows: items,
      idOf: (b) => '${b.id}',
      exportBaseName: 'boardings',
      searchHint: AdminLocalizations.translate(context, 'search boardings…'),
      searchText: (b) => '${b.id} ${b.title} ${b.titleAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<BoardingRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (b) => b.id,
          exportValue: (b) => '${b.id}',
          cell: (_, b) => Text('${b.id}'),
          width: 80,
        ),
        AdminColumn<BoardingRow>(
          title: AdminLocalizations.translate(context, 'image'),
          cell: (_, b) => b.imageUrl != null
              ? AppImage(
                  imagePath: b.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image_not_supported, size: 24),
          width: 80,
        ),
        AdminColumn<BoardingRow>(
          title: AdminLocalizations.translate(context, 'title (en)'),
          sortable: true,
          sortValue: (b) => b.title,
          exportValue: (b) => b.title,
          cell: (_, b) => Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 250,
        ),
        AdminColumn<BoardingRow>(
          title: AdminLocalizations.translate(context, 'pos'),
          sortable: true,
          sortValue: (b) => b.position,
          exportValue: (b) => '${b.position}',
          cell: (_, b) => Text('${b.position}'),
          width: 60,
        ),
        AdminColumn<BoardingRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (b) => b.isActive ? 1 : 0,
          exportValue: (b) => b.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, b) => AdminStatusBadge(isActive: b.isActive),
          width: 100,
        ),
        AdminColumn<BoardingRow>(
          title: AdminLocalizations.translate(context, 'actions'),
          cell: (_, b) => AdminTableActionsCell<BoardingRow>(
            row: b,
            onView: (boarding) {
              showDialog(
                context: context,
                builder: (_) => BoardingDetailsDialog(boarding: boarding),
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

class BoardingDetailsDialog extends StatelessWidget {
  final BoardingRow boarding;
  const BoardingDetailsDialog({super.key, required this.boarding});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: AdminLocalizations.translate(context, 'onboarding screen details'),
      id: boarding.id.toString(),
      icon: Icons.info_outline_rounded,
      children: [
        if (boarding.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                imagePath: boarding.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (en)'), boarding.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (ar)'), boarding.titleAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'position'), '${boarding.position}', Icons.sort_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'status'), boarding.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'), Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'content (en)'), boarding.content ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_rounded),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'content (ar)'), boarding.contentAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_outlined),
      ],
    );
  }
}


