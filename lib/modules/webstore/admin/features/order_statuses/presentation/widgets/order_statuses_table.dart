import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_default_badge.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/models/order_status_row.dart';

class OrderStatusesTable extends StatelessWidget {
  final List<OrderStatusRow> items;
  final Function(OrderStatusRow status) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, OrderStatusRow s)? cardBuilder;

  const OrderStatusesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<OrderStatusRow>(
      rows: items,
      idOf: (s) => '${s.id}',
      exportBaseName: 'order_statuses',
      searchHint: 'Search statuses…',
      searchText: (s) => '${s.id} ${s.name} ${s.nameAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<OrderStatusRow>(
          title: 'ID',
          sortable: true,
          sortValue: (s) => s.id,
          exportValue: (s) => '${s.id}',
          cell: (_, s) => Text('${s.id}'),
          width: 80,
        ),
        AdminColumn<OrderStatusRow>(
          title: 'Color',
          cell: (_, s) => Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _parseColor(s.color),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black12),
            ),
          ),
          width: 80,
        ),
        AdminColumn<OrderStatusRow>(
          title: 'Name',
          sortable: true,
          sortValue: (s) => s.name,
          exportValue: (s) => s.name,
          cell: (_, s) => Text(
            s.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          width: 250,
        ),
        AdminColumn<OrderStatusRow>(
          title: 'Order',
          sortable: true,
          sortValue: (s) => s.sortOrder,
          exportValue: (s) => '${s.sortOrder}',
          cell: (_, s) => Text('${s.sortOrder}'),
          width: 80,
        ),
        AdminColumn<OrderStatusRow>(
          title: 'Default',
          sortable: true,
          sortValue: (s) => s.isDefault ? 1 : 0,
          exportValue: (s) => s.isDefault ? 'Yes' : 'No',
          cell: (_, s) => AdminDefaultBadge(isDefault: s.isDefault),
          width: 100,
        ),
        AdminColumn<OrderStatusRow>(
          title: 'Status',
          sortable: true,
          sortValue: (s) => s.isActive ? 1 : 0,
          exportValue: (s) => s.isActive ? 'Active' : 'Inactive',
          cell: (_, s) => AdminStatusBadge(isActive: s.isActive),
          width: 100,
        ),
        AdminColumn<OrderStatusRow>(
          title: 'Actions',
          cell: (_, s) => AdminTableActionsCell<OrderStatusRow>(
            row: s,
            onView: (status) {
              showDialog(
                context: context,
                builder: (_) => OrderStatusDetailsDialog(status: status),
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

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }
}

class OrderStatusDetailsDialog extends StatelessWidget {
  final OrderStatusRow status;

  const OrderStatusDetailsDialog({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'Status Details',
      id: status.id.toString(),
      icon: Icons.flag_rounded,
      children: [
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Name (EN)',
                status.name,
                Icons.title_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Name (AR)',
                status.nameAr ?? 'N/A',
                Icons.translate_rounded,
                bottomPadding: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Color Indicator',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _parseColor(status.color),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Center(
                      child: Text(
                        status.color,
                        style: TextStyle(
                          color: _getContrastColor(_parseColor(status.color)),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Sort Order',
                '${status.sortOrder}',
                Icons.sort_rounded,
                bottomPadding: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Default',
                status.isDefault ? 'Yes' : 'No',
                Icons.check_circle_outline_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Active',
                status.isActive ? 'Yes' : 'No',
                Icons.toggle_on_rounded,
                bottomPadding: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return Colors.grey;
    }
  }

  Color _getContrastColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.light
        ? Colors.black
        : Colors.white;
  }
}
