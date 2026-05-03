import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_default_badge.dart';
import 'package:erp/modules/webstore/admin/features/properties/data/models/property_row.dart';

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
      searchHint: 'Search properties…',
      searchText: (p) => '${p.id} ${p.title} ${p.titleAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PropertyRow>(
          title: 'ID',
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PropertyRow>(
          title: 'Title',
          sortable: true,
          sortValue: (p) => p.title,
          exportValue: (p) => p.title,
          cell: (_, p) => Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 300,
        ),
        AdminColumn<PropertyRow>(
          title: 'Default',
          sortable: true,
          sortValue: (p) => p.isDefault ? 1 : 0,
          exportValue: (p) => p.isDefault ? 'Yes' : 'No',
          cell: (_, p) => AdminDefaultBadge(isDefault: p.isDefault),
          width: 120,
        ),
        AdminColumn<PropertyRow>(
          title: 'Status',
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? 'Active' : 'Inactive',
          cell: (_, p) => AdminStatusBadge(isActive: p.isActive),
          width: 100,
        ),
        AdminColumn<PropertyRow>(
          title: 'Actions',
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
      title: 'Property Details',
      id: property.id.toString(),
      icon: Icons.settings_input_component_rounded,
      children: [
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (EN)', property.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (AR)', property.titleAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Default', property.isDefault ? 'Yes' : 'No', Icons.check_circle_outline_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Status', property.isActive ? 'Active' : 'Inactive', Icons.toggle_on_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Property URL', property.propertyUrl ?? 'N/A', Icons.link_rounded),
        if (property.parentId != null)
          AdminDetailsDialog.buildDetailRow(context, 'Parent ID', '${property.parentId}', Icons.account_tree_rounded),
        if (property.companyId != null)
          AdminDetailsDialog.buildDetailRow(context, 'Company ID', '${property.companyId}', Icons.business_rounded),
      ],
    );
  }
}
