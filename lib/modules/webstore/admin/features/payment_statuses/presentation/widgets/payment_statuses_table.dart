import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/models/payment_status_row.dart';

class PaymentStatusesTable extends StatelessWidget {
  final List<PaymentStatusRow> items;
  final Function(PaymentStatusRow s) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, PaymentStatusRow s)? cardBuilder;

  const PaymentStatusesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PaymentStatusRow>(
      rows: items,
      idOf: (s) => '${s.id}',
      exportBaseName: 'payment_statuses',
      searchHint: 'Search statuses…',
      searchText: (s) => '${s.id} ${s.name} ${s.nameAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PaymentStatusRow>(
          title: 'ID',
          sortable: true,
          sortValue: (s) => s.id,
          exportValue: (s) => '${s.id}',
          cell: (_, s) => Text('${s.id}'),
          width: 80,
        ),
        AdminColumn<PaymentStatusRow>(
          title: 'Name',
          sortable: true,
          sortValue: (s) => s.name,
          exportValue: (s) => s.name,
          cell: (_, s) => Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 200,
        ),
        AdminColumn<PaymentStatusRow>(
          title: 'Arabic Name',
          sortable: true,
          sortValue: (s) => s.nameAr ?? '',
          exportValue: (s) => s.nameAr ?? '',
          cell: (_, s) => Text(s.nameAr ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 200,
        ),
        AdminColumn<PaymentStatusRow>(
          title: 'Order',
          sortable: true,
          sortValue: (s) => s.sortOrder,
          exportValue: (s) => '${s.sortOrder}',
          cell: (_, s) => Text('${s.sortOrder}'),
          width: 80,
        ),
        AdminColumn<PaymentStatusRow>(
          title: 'Status',
          sortable: true,
          sortValue: (s) => s.isActive ? 1 : 0,
          exportValue: (s) => s.isActive ? 'Active' : 'Inactive',
          cell: (_, s) => AdminStatusBadge(isActive: s.isActive),
          width: 110,
        ),
        AdminColumn<PaymentStatusRow>(
          title: 'Actions',
          cell: (_, s) => AdminTableActionsCell<PaymentStatusRow>(
            row: s,
            onView: (s) {
              showDialog(
                context: context,
                builder: (_) => PaymentStatusDetailsDialog(status: s),
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

class PaymentStatusDetailsDialog extends StatelessWidget {
  final PaymentStatusRow status;
  const PaymentStatusDetailsDialog({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'Payment Status Details',
      id: status.id.toString(),
      icon: Icons.info_rounded,
      children: [
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (EN)', status.name, Icons.language_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (AR)', status.nameAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Sort Order', '${status.sortOrder}', Icons.sort_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Active', status.isActive ? 'Yes' : 'No', Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
      ],
    );
  }
}
