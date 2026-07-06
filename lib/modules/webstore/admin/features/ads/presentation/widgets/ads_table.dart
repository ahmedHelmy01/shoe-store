import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/ads/data/models/ad_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
      searchHint: AdminLocalizations.translate(context, 'search advertisements…'),
      searchText: (a) => '${a.id} ${a.title} ${a.location ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<AdRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (a) => a.id,
          exportValue: (a) => '${a.id}',
          cell: (_, a) => Text('${a.id}'),
          width: 80,
        ),
        AdminColumn<AdRow>(
          title: AdminLocalizations.translate(context, 'image'),
          cell: (_, a) => a.imageUrl != null
              ? AppImage(
                  imagePath: a.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image_not_supported, size: 24),
          width: 80,
        ),
        AdminColumn<AdRow>(
          title: AdminLocalizations.translate(context, 'title (en)'),
          sortable: true,
          sortValue: (a) => a.title,
          exportValue: (a) => a.title,
          cell: (_, a) => Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 260,
        ),
        AdminColumn<AdRow>(
          title: AdminLocalizations.translate(context, 'location'),
          cell: (_, a) => Text(a.location ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 150,
        ),
        AdminColumn<AdRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (a) => a.isActive ? 1 : 0,
          exportValue: (a) => a.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, a) => AdminStatusBadge(isActive: a.isActive),
          width: 100,
        ),
        AdminColumn<AdRow>(
          title: AdminLocalizations.translate(context, 'actions'),
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
      title: AdminLocalizations.translate(context, 'advertisement details'),
      id: ad.id.toString(),
      icon: Icons.ads_click_rounded,
      children: [
        if (ad.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                imagePath: ad.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (en)'), ad.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (ar)'), ad.titleAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'location'), ad.location ?? AdminLocalizations.translate(context, 'n/a'), Icons.location_on_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'status'), ad.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'), Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'content (en)'), ad.content ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_rounded),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'content (ar)'), ad.contentAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_outlined),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'target url'), ad.linkUrl ?? AdminLocalizations.translate(context, 'n/a'), Icons.link_rounded),
        if (ad.productCategoryId != null)
          AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'category link id'), ad.productCategoryId.toString(), Icons.category_rounded),
      ],
    );
  }
}
