import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_default_badge.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/models/property_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class PropertiesTable extends StatelessWidget {
  final List<PropertyRow> items;
  final Function(PropertyRow property) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, PropertyRow p)? cardBuilder;

  const PropertiesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PropertyRow>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'properties',
      searchHint: AdminLocalizations.translate(context, 'search properties…'),
      searchText: (p) => '${p.id} ${p.title} ${p.titleAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PropertyRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PropertyRow>(
          title: AdminLocalizations.translate(context, 'title (en)'),
          sortable: true,
          sortValue: (p) => p.title,
          exportValue: (p) => p.title,
          cell: (_, p) => Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 300,
        ),
        AdminColumn<PropertyRow>(
          title: AdminLocalizations.translate(context, 'default'),
          sortable: true,
          sortValue: (p) => p.isDefault ? 1 : 0,
          exportValue: (p) => p.isDefault ? AdminLocalizations.translate(context, 'yes') : AdminLocalizations.translate(context, 'no'),
          cell: (_, p) => AdminDefaultBadge(isDefault: p.isDefault),
          width: 120,
        ),
        AdminColumn<PropertyRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, p) => AdminStatusBadge(isActive: p.isActive),
          width: 100,
        ),
        AdminColumn<PropertyRow>(
          title: AdminLocalizations.translate(context, 'actions'),
          cell: (_, p) => AdminTableActionsCell<PropertyRow>(
            row: p,
            onView: (prop) {
              showDialog(
                context: context,
                builder: (_) => PropertyDetailsDialog(property: prop),
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

class PropertyDetailsDialog extends StatelessWidget {
  final PropertyRow property;
  const PropertyDetailsDialog({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: AdminLocalizations.translate(context, 'property details'),
      id: property.id.toString(),
      icon: Icons.settings_input_component_rounded,
      children: [
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (en)'), property.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (ar)'), property.titleAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'default'), property.isDefault ? AdminLocalizations.translate(context, 'yes') : AdminLocalizations.translate(context, 'no'), Icons.check_circle_outline_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'status'), property.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'), Icons.toggle_on_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'property url'), property.propertyUrl ?? AdminLocalizations.translate(context, 'n/a'), Icons.link_rounded),
        if (property.parentId != null)
          AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'parent id'), '${property.parentId}', Icons.account_tree_rounded),
        if (property.companyId != null)
          AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'company id'), '${property.companyId}', Icons.business_rounded),
      ],
    );
  }
}
