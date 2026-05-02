import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/ads/data/models/ad_row.dart';

class AdsTable extends StatelessWidget {
  final List<AdRow> items;
  final Function(AdRow ad) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, AdRow ad)? cardBuilder;

  const AdsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<AdRow>(
      rows: items,
      idOf: (a) => '${a.id}',
      exportBaseName: 'ads',
      searchHint: 'Search advertisements…',
      searchText: (a) => '${a.id} ${a.title} ${a.location ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<AdRow>(
          title: 'ID',
          sortable: true,
          sortValue: (a) => a.id,
          exportValue: (a) => '${a.id}',
          cell: (_, a) => Text('${a.id}'),
          width: 80,
        ),
        AdminColumn<AdRow>(
          title: 'Image',
          cell: (_, a) => a.image != null
              ? Image.network(
                  a.image!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 24),
                )
              : const Icon(Icons.image_not_supported, size: 24),
          width: 80,
        ),
        AdminColumn<AdRow>(
          title: 'Title',
          sortable: true,
          sortValue: (a) => a.title,
          exportValue: (a) => a.title,
          cell: (_, a) => Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<AdRow>(
          title: 'Location',
          cell: (_, a) => Text(a.location ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 150,
        ),
        AdminColumn<AdRow>(
          title: 'Status',
          sortable: true,
          sortValue: (a) => a.isActive ? 1 : 0,
          exportValue: (a) => a.isActive ? 'Active' : 'Inactive',
          cell: (_, a) => AdminStatusBadge(isActive: a.isActive),
          width: 100,
        ),
        AdminColumn<AdRow>(
          title: 'Actions',
          cell: (_, a) => AdminTableActionsCell<AdRow>(
            row: a,
            onView: (ad) {
              showDialog(
                context: context,
                builder: (_) => AdDetailsDialog(ad: ad),
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

class AdDetailsDialog extends StatelessWidget {
  final AdRow ad;
  const AdDetailsDialog({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'Advertisement Details',
      id: ad.id.toString(),
      icon: Icons.ads_click_rounded,
      children: [
        if (ad.image != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                ad.image!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (EN)', ad.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (AR)', ad.titleAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Location', ad.location ?? 'N/A', Icons.location_on_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Status', ad.isActive ? 'Active' : 'Inactive', Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Content (EN)', ad.content ?? 'N/A', Icons.description_rounded),
        AdminDetailsDialog.buildDetailRow(context, 'Content (AR)', ad.contentAr ?? 'N/A', Icons.description_outlined),
        AdminDetailsDialog.buildDetailRow(context, 'Target URL', ad.linkUrl ?? 'N/A', Icons.link_rounded),
      ],
    );
  }
}
