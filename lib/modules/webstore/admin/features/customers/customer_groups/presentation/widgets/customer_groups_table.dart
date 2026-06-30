import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_default_badge.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/features/customers/customer_groups/data/models/customer_group_row.dart';

class CustomerGroupsTable extends StatelessWidget {
  final List<CustomerGroupRow> items;
  final Function(CustomerGroupRow group) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, CustomerGroupRow g)? cardBuilder;

  const CustomerGroupsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CustomerGroupRow>(
      rows: items,
      idOf: (g) => '${g.id}',
      exportBaseName: 'customer_groups',
      searchHint: AdminLocalizations.translate(context, 'Search groups…'),
      searchText: (g) => '${g.id} ${g.title} ${g.titleAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<CustomerGroupRow>(
          title: AdminLocalizations.translate(context, 'ID'),
          sortable: true,
          sortValue: (g) => g.id,
          exportValue: (g) => '${g.id}',
          cell: (_, g) => Text('${g.id}'),
          width: 80,
        ),
        AdminColumn<CustomerGroupRow>(
          title: AdminLocalizations.translate(context, 'Title'),
          sortable: true,
          sortValue: (g) => g.title,
          exportValue: (g) => g.title,
          cell: (_, g) => Text(g.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 300,
        ),
        AdminColumn<CustomerGroupRow>(
          title: AdminLocalizations.translate(context, 'Default'),
          sortable: true,
          sortValue: (g) => g.isDefault ? 1 : 0,
          exportValue: (g) => g.isDefault ? AdminLocalizations.translate(context, 'Yes') : AdminLocalizations.translate(context, 'No'),
          cell: (_, g) => AdminDefaultBadge(isDefault: g.isDefault),
          width: 120,
        ),
        AdminColumn<CustomerGroupRow>(
          title: AdminLocalizations.translate(context, 'Status'),
          sortable: true,
          sortValue: (g) => g.isActive ? 1 : 0,
          exportValue: (g) => g.isActive ? AdminLocalizations.translate(context, 'Active') : AdminLocalizations.translate(context, 'Inactive'),
          cell: (_, g) => AdminStatusBadge(isActive: g.isActive),
          width: 120,
        ),
        AdminColumn<CustomerGroupRow>(
          title: AdminLocalizations.translate(context, 'Actions'),
          cell: (_, g) => AdminTableActionsCell<CustomerGroupRow>(
            row: g,
            onView: (group) {
              showDialog(
                context: context,
                builder: (_) => CustomerGroupDetailsDialog(group: group),
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

class CustomerGroupDetailsDialog extends StatelessWidget {
  final CustomerGroupRow group;
  const CustomerGroupDetailsDialog({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: AdminLocalizations.translate(context, 'Group Details'),
      id: group.id.toString(),
      icon: Icons.groups_rounded,
      children: [
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Title (EN)'), group.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Title (AR)'), group.titleAr ?? AdminLocalizations.translate(context, 'N/A'), Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: group.parentId != null
                  ? AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Parent ID'), '${group.parentId}', Icons.account_tree_rounded, bottomPadding: 0)
                  : AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Parent ID'), AdminLocalizations.translate(context, 'N/A'), Icons.account_tree_rounded, bottomPadding: 0),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: group.companyId != null
                  ? AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Company ID'), '${group.companyId}', Icons.business_rounded, bottomPadding: 0)
                  : AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Company ID'), AdminLocalizations.translate(context, 'N/A'), Icons.business_rounded, bottomPadding: 0),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Default'), group.isDefault ? AdminLocalizations.translate(context, 'Yes') : AdminLocalizations.translate(context, 'No'), Icons.check_circle_outline_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Status'), group.isActive ? AdminLocalizations.translate(context, 'Active') : AdminLocalizations.translate(context, 'Inactive'), Icons.toggle_on_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Created At'), group.createdAt?.toString() ?? AdminLocalizations.translate(context, 'N/A'), Icons.calendar_today_rounded),
      ],
    );
  }
}
