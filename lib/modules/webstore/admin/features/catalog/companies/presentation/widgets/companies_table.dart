import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/data/models/company_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class CompaniesTable extends StatelessWidget {
  final List<CompanyRow> items;
  final Function(CompanyRow company) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, CompanyRow c)? cardBuilder;

  const CompaniesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CompanyRow>(
      rows: items,
      idOf: (c) => '${c.id}',
      exportBaseName: 'companies',
      searchHint: AdminLocalizations.translate(context, 'search by name or code…'),
      searchText: (c) => '${c.id} ${c.name} ${c.nameAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<CompanyRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (c) => c.id,
          exportValue: (c) => '${c.id}',
          cell: (_, c) => Text('#${c.id}', style: const TextStyle(fontFamily: 'monospace')),
          width: 80,
        ),
        AdminColumn<CompanyRow>(
          title: AdminLocalizations.translate(context, 'name'),
          sortable: true,
          sortValue: (c) => c.name,
          exportValue: (c) => c.name,
          cell: (_, c) => Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 250,
        ),
        AdminColumn<CompanyRow>(
          title: AdminLocalizations.translate(context, 'arabic name'),
          sortable: true,
          sortValue: (c) => c.nameAr ?? '',
          exportValue: (c) => c.nameAr ?? '',
          cell: (_, c) => Text(c.nameAr ?? '-', style: const TextStyle(fontWeight: FontWeight.w600)),
          width: 200,
        ),
        AdminColumn<CompanyRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (c) => c.isActive ? 1 : 0,
          exportValue: (c) => c.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, c) => AdminStatusBadge(isActive: c.isActive),
          width: 100,
        ),
        AdminColumn<CompanyRow>(
          title: AdminLocalizations.translate(context, 'actions'),
          cell: (_, c) => AdminTableActionsCell<CompanyRow>(
            row: c,
            onView: (c) {
              showDialog(
                context: context,
                builder: (context) => AdminDetailsDialog(
                  title: AdminLocalizations.translate(context, 'company details'),
                  id: c.id.toString(),
                  icon: Icons.business_rounded,
                  children: [
                    if (c.logoUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AppImage(
                            imagePath: c.logoUrl!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (en)'), c.name, Icons.language_rounded, bottomPadding: 0)),
                        const SizedBox(width: 16),
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'name (ar)'), c.nameAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'description (en)'), c.description?.isNotEmpty == true ? c.description! : AdminLocalizations.translate(context, 'n/a'), Icons.description_rounded, bottomPadding: 0)),
                        const SizedBox(width: 16),
                        Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'description (ar)'), c.descriptionAr?.isNotEmpty == true ? c.descriptionAr! : AdminLocalizations.translate(context, 'n/a'), Icons.description_outlined, bottomPadding: 0)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AdminDetailsDialog.buildStatusRow(context, c.isActive),
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

