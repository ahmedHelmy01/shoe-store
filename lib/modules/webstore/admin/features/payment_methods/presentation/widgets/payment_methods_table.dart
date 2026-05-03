import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';

class PaymentMethodsTable extends StatelessWidget {
  final List<PaymentMethodRow> items;
  final Function(PaymentMethodRow m) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, PaymentMethodRow m)? cardBuilder;

  const PaymentMethodsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PaymentMethodRow>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'payment_methods',
      searchHint: 'Search payment methods…',
      searchText: (p) => '${p.id} ${p.name} ${p.nameAr ?? ''} ${p.type}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PaymentMethodRow>(
          title: 'ID',
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PaymentMethodRow>(
          title: 'Name',
          sortable: true,
          sortValue: (p) => p.name,
          exportValue: (p) => p.name,
          cell: (_, p) => Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 200,
        ),
        AdminColumn<PaymentMethodRow>(
          title: 'Arabic Name',
          sortable: true,
          sortValue: (p) => p.nameAr ?? '',
          exportValue: (p) => p.nameAr ?? '',
          cell: (_, p) => Text(p.nameAr ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 200,
        ),
        AdminColumn<PaymentMethodRow>(
          title: 'Order',
          sortable: true,
          sortValue: (p) => p.sortOrder,
          exportValue: (p) => '${p.sortOrder}',
          cell: (_, p) => Text('${p.sortOrder}'),
          width: 80,
        ),
        AdminColumn<PaymentMethodRow>(
          title: 'Status',
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? 'Active' : 'Inactive',
          cell: (_, p) => AdminStatusBadge(isActive: p.isActive),
          width: 100,
        ),
        AdminColumn<PaymentMethodRow>(
          title: 'Actions',
          cell: (_, p) => AdminTableActionsCell<PaymentMethodRow>(
            row: p,
            onView: (p) {
              showDialog(
                context: context,
                builder: (_) => PaymentMethodDetailsDialog(method: p),
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

class PaymentMethodDetailsDialog extends StatelessWidget {
  final PaymentMethodRow method;
  const PaymentMethodDetailsDialog({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'Payment Method Details',
      id: method.id.toString(),
      icon: Icons.payment_rounded,
      children: [
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (EN)', method.name, Icons.language_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (AR)', method.nameAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Status', method.isActive ? 'Active' : 'Inactive', Icons.check_circle_outline_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Sort Order', '${method.sortOrder}', Icons.sort_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Note (EN)', method.note ?? 'No notes', Icons.note_rounded),
        AdminDetailsDialog.buildDetailRow(context, 'Note (AR)', method.noteAr ?? 'لا توجد ملاحظات', Icons.note_alt_rounded),
      ],
    );
  }
}
