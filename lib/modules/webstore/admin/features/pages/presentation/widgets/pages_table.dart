import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';

class PagesTable extends StatelessWidget {
  final List<PageRow> items;
  final Function(PageRow page) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, PageRow p)? cardBuilder;

  const PagesTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<PageRow>(
      rows: items,
      idOf: (p) => '${p.id}',
      exportBaseName: 'pages',
      searchHint: 'Search pages…',
      searchText: (p) => '${p.id} ${p.title} ${p.slug}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PageRow>(
          title: 'ID',
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PageRow>(
          title: 'Image',
          cell: (_, p) => p.imageUrl != null
              ? Image.network(
                  p.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 24),
                )
              : const Icon(Icons.image_not_supported, size: 24),
          width: 80,
        ),
        AdminColumn<PageRow>(
          title: 'Title',
          sortable: true,
          sortValue: (p) => p.title,
          exportValue: (p) => p.title,
          cell: (_, p) => Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 250,
        ),
        AdminColumn<PageRow>(
          title: 'Slug',
          sortable: true,
          sortValue: (p) => p.slug,
          exportValue: (p) => p.slug,
          cell: (_, p) => Text(p.slug),
          width: 180,
        ),
        AdminColumn<PageRow>(
          title: 'Status',
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? 'Active' : 'Inactive',
          cell: (_, p) => AdminStatusBadge(isActive: p.isActive),
          width: 100,
        ),
        AdminColumn<PageRow>(
          title: 'Actions',
          cell: (_, p) => AdminTableActionsCell<PageRow>(
            row: p,
            onView: (page) {
              showDialog(
                context: context,
                builder: (_) => PageDetailsDialog(page: page),
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

class PageDetailsDialog extends StatelessWidget {
  final PageRow page;
  const PageDetailsDialog({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return AdminDetailsDialog(
      title: 'Page Details',
      id: page.id.toString(),
      icon: Icons.article_rounded,
      children: [
        if (page.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                page.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (EN)', page.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Title (AR)', page.titleAr ?? 'N/A', Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Slug', '/${page.slug}', Icons.link_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, 'Status', page.isActive ? 'Published' : 'Draft', Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, 'Content (EN)', page.content ?? 'N/A', Icons.description_rounded),
        AdminDetailsDialog.buildDetailRow(context, 'Content (AR)', page.contentAr ?? 'N/A', Icons.description_outlined),
      ],
    );
  }
}
