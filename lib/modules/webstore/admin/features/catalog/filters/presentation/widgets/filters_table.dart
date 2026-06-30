import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/data/models/filter_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
          sortValue: (f) => f.nameEn ?? f.name,
          exportValue: (f) => f.nameEn ?? f.name,
          cell: (_, f) => Text(f.nameEn ?? f.name, style: const TextStyle(fontWeight: FontWeight.w600)),
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
          title: 'Color',
          sortable: true,
          sortValue: (f) => f.colorCode ?? '',
          exportValue: (f) => f.colorCode ?? '',
          cell: (_, f) {
            final color = () {
              try {
                var hex = f.colorCode ?? '#6366f1';
                if (!hex.startsWith('#')) hex = '#$hex';
                return Color(int.parse(hex.replaceFirst('#', '0xFF')));
              } catch (_) {
                return Colors.grey;
              }
            }();
            return Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              ],
            );
          },
          width: 80,
        ),
        AdminColumn<FilterRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (f) => f.isActive ? 1 : 0,
          exportValue: (f) => f.isActive ? 'Active' : 'Inactive',
          cell: (_, f) => AdminStatusBadge(isActive: f.isActive),
          width: 100,
        ),
        AdminColumn<FilterRow>(
          title: AdminLocalizations.translate(context, 'actions'),
          cell: (_, f) => AdminTableActionsCell<FilterRow>(
            row: f,
            onView: (f) {
              final parentTagName = () {
                final parentId = f.parentId;
                if (parentId == null || parentId == 0) return 'None (لا يوجد)';
                for (final item in items) {
                  if (item.id == parentId) return item.name;
                }
                return 'ID: $parentId';
              }();

              showDialog(
                context: context,
                builder: (context) => AdminDetailsDialog(
                  title: AdminLocalizations.translate(context, 'tag details'),
                  id: f.id.toString(),
                  icon: Icons.local_offer_rounded,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (en)'), f.nameEn ?? f.name, Icons.language_rounded, bottomPadding: 0)),
                        const SizedBox(width: 16),
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (ar)'), f.nameAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'parent tag'), parentTagName, Icons.account_tree_rounded, bottomPadding: 0)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: AdminDetailsDialog.buildDetailRow(
                                  context,
                                  AdminLocalizations.translate(context, 'color'),
                                  f.colorCode ?? '#6366f1',
                                  Icons.palette_rounded,
                                  bottomPadding: 0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: () {
                                      try {
                                        var hex = f.colorCode ?? '#6366f1';
                                        if (!hex.startsWith('#')) hex = '#$hex';
                                        return Color(int.parse(hex.replaceFirst('#', '0xFF')));
                                      } catch (_) {
                                        return Colors.grey;
                                      }
                                    }(),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

