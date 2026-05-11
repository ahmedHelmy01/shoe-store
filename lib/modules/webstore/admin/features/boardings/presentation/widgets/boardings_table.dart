import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/boardings/data/models/boarding_row.dart';

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
      searchHint: 'Search boardings…',
      searchText: (b) => '${b.id} ${b.title} ${b.titleAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<BoardingRow>(
          title: 'ID',
          sortable: true,
          sortValue: (b) => b.id,
          exportValue: (b) => '${b.id}',
          cell: (_, b) => Text('${b.id}'),
          width: 80,
        ),
        AdminColumn<BoardingRow>(
          title: 'Image',
          cell: (_, b) => b.imageUrl != null
              ? Image.network(
                  b.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 24),
                )
              : const Icon(Icons.image_not_supported, size: 24),
          width: 80,
        ),
        AdminColumn<BoardingRow>(
          title: 'Title',
          sortable: true,
          sortValue: (b) => b.title,
          exportValue: (b) => b.title,
          cell: (_, b) => Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 250,
        ),
        AdminColumn<BoardingRow>(
          title: 'Pos',
          sortable: true,
          sortValue: (b) => b.position,
          exportValue: (b) => '${b.position}',
          cell: (_, b) => Text('${b.position}'),
          width: 60,
        ),
        AdminColumn<BoardingRow>(
          title: 'Status',
          sortable: true,
          sortValue: (b) => b.isActive ? 1 : 0,
          exportValue: (b) => b.isActive ? 'Active' : 'Inactive',
          cell: (_, b) => AdminStatusBadge(isActive: b.isActive),
          width: 100,
        ),
        AdminColumn<BoardingRow>(
          title: 'Actions',
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
      title: 'Onboarding Screen Details',
      id: boarding.id.toString(),
      icon: Icons.info_outline_rounded,
      children: [
        if (boarding.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                boarding.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (EN)', boarding.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (AR)', boarding.titleAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Position', '${boarding.position}', Icons.sort_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Status', boarding.isActive ? 'Active' : 'Inactive', Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Content (EN)', boarding.content ?? 'N/A', Icons.description_rounded),
        AdminDetailsDialog.buildDetailRow(context, 'Content (AR)', boarding.contentAr ?? 'N/A', Icons.description_outlined),
      ],
    );
  }
}


