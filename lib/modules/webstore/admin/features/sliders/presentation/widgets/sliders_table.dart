import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/models/slider_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class SlidersTable extends StatelessWidget {
  final List<SliderRow> items;
  final Function(SliderRow slider) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, SliderRow s)? cardBuilder;

  const SlidersTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<SliderRow>(
      rows: items,
      idOf: (s) => '${s.id}',
      exportBaseName: 'sliders',
      searchHint: AdminLocalizations.translate(context, 'search sliders…'),
      searchText: (s) => '${s.id} ${s.title} ${s.titleAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<SliderRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (s) => s.id,
          exportValue: (s) => '${s.id}',
          cell: (_, s) => Text('${s.id}'),
          width: 80,
        ),
        AdminColumn<SliderRow>(
          title: AdminLocalizations.translate(context, 'image'),
          cell: (_, s) => s.imageUrl != null
              ? AppImage(
                  imagePath: s.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image_not_supported, size: 24),
          width: 80,
        ),
        AdminColumn<SliderRow>(
          title: AdminLocalizations.translate(context, 'title (en)'),
          sortable: true,
          sortValue: (s) => s.title,
          exportValue: (s) => s.title,
          cell: (_, s) => Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 250,
        ),
        AdminColumn<SliderRow>(
          title: AdminLocalizations.translate(context, 'pos'),
          sortable: true,
          sortValue: (s) => s.position,
          exportValue: (s) => '${s.position}',
          cell: (_, s) => Text('${s.position}'),
          width: 60,
        ),
        AdminColumn<SliderRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (s) => s.isActive ? 1 : 0,
          exportValue: (s) => s.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, s) => AdminStatusBadge(isActive: s.isActive),
          width: 100,
        ),
        AdminColumn<SliderRow>(
          title: AdminLocalizations.translate(context, 'actions'),
          cell: (_, s) => AdminTableActionsCell<SliderRow>(
            row: s,
            onView: (slider) {
              showDialog(
                context: context,
                builder: (_) => SliderDetailsDialog(slider: slider),
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

class SliderDetailsDialog extends StatelessWidget {
  final SliderRow slider;
  const SliderDetailsDialog({super.key, required this.slider});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: AdminLocalizations.translate(context, 'slider details'),
      id: slider.id.toString(),
      icon: Icons.slideshow_rounded,
      children: [
        if (slider.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppImage(
                imagePath: slider.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (en)'), slider.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (ar)'), slider.titleAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'position'), '${slider.position}', Icons.sort_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'status'), slider.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'), Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'content (en)'), slider.content ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_rounded),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'content (ar)'), slider.contentAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_outlined),
      ],
    );
  }
}

