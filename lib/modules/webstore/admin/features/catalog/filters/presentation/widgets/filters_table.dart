import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';

class FiltersTable extends StatelessWidget {
  final List<FilterRow> items;
  final Function(FilterRow f) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, FilterRow f)? cardBuilder;

  const FiltersTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<FilterRow>(
      rows: items,
      idOf: (f) => '${f.id}',
      exportBaseName: 'tags',
      searchHint: 'Search tags…',
      searchText: (f) => '${f.id} ${f.name}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<FilterRow>(
          title: 'ID',
          sortable: true,
          sortValue: (f) => f.id,
          exportValue: (f) => '${f.id}',
          cell: (_, f) => Text('${f.id}'),
          width: 80,
        ),
        AdminColumn<FilterRow>(
          title: 'Name',
          sortable: true,
          sortValue: (f) => f.name,
          exportValue: (f) => f.name,
          cell: (_, f) => Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 250,
        ),
        AdminColumn<FilterRow>(
          title: 'Arabic Name',
          sortable: true,
          sortValue: (f) => f.nameAr ?? '',
          exportValue: (f) => f.nameAr ?? '',
          cell: (_, f) => Text(f.nameAr ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 200,
        ),

        AdminColumn<FilterRow>(
          title: 'Status',
          sortable: true,
          sortValue: (f) => f.isActive ? 1 : 0,
          exportValue: (f) => f.isActive ? 'Active' : 'Inactive',
          cell: (_, f) => AdminStatusBadge(isActive: f.isActive),
          width: 100,
        ),
        AdminColumn<FilterRow>(
          title: 'Actions',
          cell: (_, f) => AdminTableActionsCell<FilterRow>(
            row: f,
            onView: (f) {
              showDialog(
                context: context,
                builder: (context) => AdminDetailsDialog(
                  title: 'Tag Details',
                  id: f.id.toString(),
                  icon: Icons.local_offer_rounded,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (EN)', f.name, Icons.language_rounded, bottomPadding: 0)),
                        const SizedBox(width: 16),
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Name (AR)', f.nameAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AdminDetailsDialog.buildStatusRow(context, f.isActive),
                  ],
                ),
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

