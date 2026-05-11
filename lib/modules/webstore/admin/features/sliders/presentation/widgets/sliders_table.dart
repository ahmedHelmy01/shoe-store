import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/models/slider_row.dart';

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
      searchHint: 'Search sliders…',
      searchText: (s) => '${s.id} ${s.title} ${s.titleAr ?? ''}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<SliderRow>(
          title: 'ID',
          sortable: true,
          sortValue: (s) => s.id,
          exportValue: (s) => '${s.id}',
          cell: (_, s) => Text('${s.id}'),
          width: 80,
        ),
        AdminColumn<SliderRow>(
          title: 'Image',
          cell: (_, s) => s.imageUrl != null
              ? Image.network(
                  s.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 24),
                )
              : const Icon(Icons.image_not_supported, size: 24),
          width: 80,
        ),
        AdminColumn<SliderRow>(
          title: 'Title',
          sortable: true,
          sortValue: (s) => s.title,
          exportValue: (s) => s.title,
          cell: (_, s) => Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 250,
        ),
        AdminColumn<SliderRow>(
          title: 'Pos',
          sortable: true,
          sortValue: (s) => s.position,
          exportValue: (s) => '${s.position}',
          cell: (_, s) => Text('${s.position}'),
          width: 60,
        ),
        AdminColumn<SliderRow>(
          title: 'Status',
          sortable: true,
          sortValue: (s) => s.isActive ? 1 : 0,
          exportValue: (s) => s.isActive ? 'Active' : 'Inactive',
          cell: (_, s) => AdminStatusBadge(isActive: s.isActive),
          width: 100,
        ),
        AdminColumn<SliderRow>(
          title: 'Actions',
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
      title: 'Slider Details',
      id: slider.id.toString(),
      icon: Icons.slideshow_rounded,
      children: [
        if (slider.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                slider.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image_outlined, size: 36, color: Colors.grey.withValues(alpha: 0.5)),
                        const SizedBox(height: 8),
                        Text(
                          'Image saved on server',
                          style: TextStyle(color: Colors.grey.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (EN)', slider.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (AR)', slider.titleAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Position', '${slider.position}', Icons.sort_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Status', slider.isActive ? 'Active' : 'Inactive', Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Content (EN)', slider.content ?? 'N/A', Icons.description_rounded),
        AdminDetailsDialog.buildDetailRow(context, 'Content (AR)', slider.contentAr ?? 'N/A', Icons.description_outlined),
      ],
    );
  }
}

