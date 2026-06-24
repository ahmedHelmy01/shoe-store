import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/features/cities/data/models/city_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';

class CitiesTable extends StatelessWidget {
  final List<CityRow> items;
  final Function(CityRow c) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, CityRow c)? cardBuilder;

  const CitiesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<CityRow>(
      rows: items,
      idOf: (c) => '${c.id}',
      exportBaseName: 'cities',
      searchHint: 'Search cities…',
      searchText: (c) => '${c.id} ${c.name} ${c.nameEn ?? ""} ${c.nameAr ?? ""} ${c.code ?? ""} ${c.governorateName ?? ""}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<CityRow>(
          title: 'ID',
          sortable: true,
          sortValue: (c) => c.id,
          exportValue: (c) => '${c.id}',
          cell: (_, c) => Text('${c.id}'),
          width: 80,
        ),
        AdminColumn<CityRow>(
          title: 'Name',
          sortable: true,
          sortValue: (c) => c.name,
          exportValue: (c) => c.name,
          cell: (_, c) => Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 200,
        ),
        AdminColumn<CityRow>(
          title: 'Governorate',
          sortable: true,
          sortValue: (c) => c.governorateName ?? '',
          exportValue: (c) => c.governorateName ?? '',
          cell: (_, c) => Text(c.governorateName ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 200,
        ),
        AdminColumn<CityRow>(
          title: 'Fee',
          sortable: true,
          sortValue: (c) => c.deliveryFee,
          exportValue: (c) => '${c.deliveryFee}',
          cell: (_, c) => Text('${c.deliveryFee}'),
          width: 100,
        ),
        AdminColumn<CityRow>(
          title: 'Active',
          sortable: true,
          sortValue: (c) => c.isActive ? 1 : 0,
          exportValue: (c) => c.isActive ? 'Yes' : 'No',
          cell: (_, c) => AdminStatusBadge(isActive: c.isActive),
          width: 120,
        ),
        AdminColumn<CityRow>(
          title: 'Actions',
          cell: (_, c) => AdminTableActionsCell<CityRow>(
            row: c,
            onEdit: onEdit,
            onDelete: (item) => onDelete(item.id),
            onView: (it) {
              showDialog(
                context: context,
                builder: (_) => CityDetailsDialog(city: it),
              );
            },
          ),
          width: 130,
        ),
      ],
    );
  }
}

class CityDetailsDialog extends StatelessWidget {
  final CityRow city;
  const CityDetailsDialog({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'City Details',
      id: city.id.toString(),
      icon: Icons.location_city_rounded,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Name (EN)',
                city.nameEn ?? city.name,
                Icons.title_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Name (AR)',
                city.nameAr ?? 'N/A',
                Icons.translate_rounded,
                bottomPadding: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Governorate',
                city.governorateName ?? 'N/A',
                Icons.map_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Code',
                city.code ?? 'N/A',
                Icons.qr_code_rounded,
                bottomPadding: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AdminDetailsDialog.buildDetailRow(
                context,
                'Delivery Fee',
                '${city.deliveryFee}',
                Icons.delivery_dining_rounded,
                bottomPadding: 0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Container()),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildStatusRow(context, city.isActive),
      ],
    );
  }
}
