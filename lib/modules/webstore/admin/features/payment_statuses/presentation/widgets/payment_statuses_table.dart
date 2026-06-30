import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/data/models/payment_status_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
      searchHint: AdminLocalizations.translate(context, 'search statuses…'),
      searchText: (s) => '${s.id} ${s.nameEn ?? s.name} ${s.nameAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PaymentStatusRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (s) => s.id,
          exportValue: (s) => '${s.id}',
          cell: (_, s) => Text('${s.id}'),
          width: 80,
        ),
        AdminColumn<PaymentStatusRow>(
          title: AdminLocalizations.translate(context, 'name'),
          sortable: true,
          sortValue: (s) => s.nameEn ?? s.name,
          exportValue: (s) => s.nameEn ?? s.name,
          cell: (_, s) => Text(s.nameEn ?? s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 200,
        ),
        AdminColumn<PaymentStatusRow>(
          title: AdminLocalizations.translate(context, 'arabic name'),
          sortable: true,
          sortValue: (s) => s.nameAr ?? '',
          exportValue: (s) => s.nameAr ?? '',
          cell: (_, s) => Text(s.nameAr ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 200,
        ),
        AdminColumn<PaymentStatusRow>(
          title: AdminLocalizations.translate(context, 'order'),
          sortable: true,
          sortValue: (s) => s.sortOrder,
          exportValue: (s) => '${s.sortOrder}',
          cell: (_, s) => Text('${s.sortOrder}'),
          width: 80,
        ),
        AdminColumn<PaymentStatusRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (s) => s.isActive ? 1 : 0,
          exportValue: (s) => s.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, s) => AdminStatusBadge(isActive: s.isActive),
          width: 110,
        ),
        AdminColumn<PaymentStatusRow>(
          title: AdminLocalizations.translate(context, 'actions'),
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
      title: AdminLocalizations.translate(context, 'payment status details'),
      id: status.id.toString(),
      icon: Icons.info_rounded,
      children: [
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (en)'), status.nameEn ?? status.name, Icons.language_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (ar)'), status.nameAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'sort order'), '${status.sortOrder}', Icons.sort_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'active'), status.isActive ? AdminLocalizations.translate(context, 'yes') : AdminLocalizations.translate(context, 'no'), Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
      ],
    );
  }
}
