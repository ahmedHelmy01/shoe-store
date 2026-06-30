import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_default_badge.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/models/order_status_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
      searchHint: AdminLocalizations.translate(context, 'search statuses…'),
      searchText: (s) => '${s.id} ${s.name} ${s.nameAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<OrderStatusRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (s) => s.id,
          exportValue: (s) => '${s.id}',
          cell: (_, s) => Text('${s.id}'),
          width: 80,
        ),
        AdminColumn<OrderStatusRow>(
          title: AdminLocalizations.translate(context, 'color'),
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
          title: AdminLocalizations.translate(context, 'name'),
          sortable: true,
          sortValue: (s) => s.name,
          exportValue: (s) => s.name,
          cell: (context, s) => Text(
            s.displayName(Localizations.localeOf(context).languageCode),
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          width: 250,
        ),
        AdminColumn<OrderStatusRow>(
          title: AdminLocalizations.translate(context, 'order'),
          sortable: true,
          sortValue: (s) => s.sortOrder,
          exportValue: (s) => '${s.sortOrder}',
          cell: (_, s) => Text('${s.sortOrder}'),
          width: 80,
        ),
        AdminColumn<OrderStatusRow>(
          title: AdminLocalizations.translate(context, 'default'),
          sortable: true,
          sortValue: (s) => s.isDefault ? 1 : 0,
          exportValue: (s) => s.isDefault ? AdminLocalizations.translate(context, 'yes') : AdminLocalizations.translate(context, 'no'),
          cell: (_, s) => AdminDefaultBadge(isDefault: s.isDefault),
          width: 100,
        ),
        AdminColumn<OrderStatusRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (s) => s.isActive ? 1 : 0,
          exportValue: (s) => s.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, s) => AdminStatusBadge(isActive: s.isActive),
          width: 100,
        ),
        AdminColumn<OrderStatusRow>(
          title: AdminLocalizations.translate(context, 'actions'),
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
      title: AdminLocalizations.translate(context, 'status details'),
      id: status.id.toString(),
      icon: Icons.flag_rounded,
      children: [
        Row(
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'name (en)'),
                status.displayNameEn.isNotEmpty ? status.displayNameEn : AdminLocalizations.translate(context, 'n/a'),
                Icons.title_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'name (ar)'),
                status.displayNameAr.isNotEmpty ? status.displayNameAr : AdminLocalizations.translate(context, 'n/a'),
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
                  Text(
                    AdminLocalizations.translate(context, 'color indicator'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                AdminLocalizations.translate(context, 'sort order'),
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
                AdminLocalizations.translate(context, 'default'),
                status.isDefault ? AdminLocalizations.translate(context, 'yes') : AdminLocalizations.translate(context, 'no'),
                Icons.check_circle_outline_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                AdminLocalizations.translate(context, 'active'),
                status.isActive ? AdminLocalizations.translate(context, 'yes') : AdminLocalizations.translate(context, 'no'),
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
