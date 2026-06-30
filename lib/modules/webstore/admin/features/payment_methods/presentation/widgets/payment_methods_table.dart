import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/data/models/payment_method_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
      searchHint: AdminLocalizations.translate(context, 'search payment methods…'),
      searchText: (p) => '${p.id} ${p.nameEn ?? p.name} ${p.nameAr ?? ''} ${p.type}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PaymentMethodRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PaymentMethodRow>(
          title: AdminLocalizations.translate(context, 'icon'),
          cell: (_, p) => p.imageUrl != null
              ? Image.network(
                  p.imageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.payment, size: 20),
                )
              : const Icon(Icons.payment, size: 20),
          width: 80,
        ),
        AdminColumn<PaymentMethodRow>(
          title: AdminLocalizations.translate(context, 'name'),
          sortable: true,
          sortValue: (p) => p.nameEn ?? p.name,
          exportValue: (p) => p.nameEn ?? p.name,
          cell: (_, p) => Text(p.nameEn ?? p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 160,
        ),
        AdminColumn<PaymentMethodRow>(
          title: AdminLocalizations.translate(context, 'arabic name'),
          sortable: true,
          sortValue: (p) => p.nameAr ?? '',
          exportValue: (p) => p.nameAr ?? '',
          cell: (_, p) => Text(p.nameAr ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 160,
        ),
        AdminColumn<PaymentMethodRow>(
          title: AdminLocalizations.translate(context, 'order'),
          sortable: true,
          sortValue: (p) => p.sortOrder,
          exportValue: (p) => '${p.sortOrder}',
          cell: (_, p) => Text('${p.sortOrder}'),
          width: 80,
        ),
        AdminColumn<PaymentMethodRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, p) => AdminStatusBadge(isActive: p.isActive),
          width: 100,
        ),
        AdminColumn<PaymentMethodRow>(
          title: AdminLocalizations.translate(context, 'actions'),
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
      title: AdminLocalizations.translate(context, 'payment method details'),
      id: method.id.toString(),
      icon: Icons.payment_rounded,
      children: [
        if (method.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  method.imageUrl!,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (en)'), method.nameEn ?? method.name, Icons.language_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (ar)'), method.nameAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'status'), method.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'), Icons.check_circle_outline_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'sort order'), '${method.sortOrder}', Icons.sort_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'type'), method.type.toUpperCase(), Icons.category_rounded),
        const SizedBox(height: 12),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'note (en)'), method.note ?? AdminLocalizations.translate(context, 'no notes'), Icons.note_rounded),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'note (ar)'), method.noteAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.note_alt_rounded),
      ],
    );
  }
}
