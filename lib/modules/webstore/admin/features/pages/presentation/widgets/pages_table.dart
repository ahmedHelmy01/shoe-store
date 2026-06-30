import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/pages/data/models/page_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
      searchHint: AdminLocalizations.translate(context, 'search pages…'),
      searchText: (p) => '${p.id} ${p.title} ${p.slug}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<PageRow>(
          title: AdminLocalizations.translate(context, 'id'),
          sortable: true,
          sortValue: (p) => p.id,
          exportValue: (p) => '${p.id}',
          cell: (_, p) => Text('${p.id}'),
          width: 80,
        ),
        AdminColumn<PageRow>(
          title: AdminLocalizations.translate(context, 'image'),
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
          title: AdminLocalizations.translate(context, 'title (en)'),
          sortable: true,
          sortValue: (p) => p.title,
          exportValue: (p) => p.title,
          cell: (_, p) => Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          width: 250,
        ),
        AdminColumn<PageRow>(
          title: AdminLocalizations.translate(context, 'slug'),
          sortable: true,
          sortValue: (p) => p.slug,
          exportValue: (p) => p.slug,
          cell: (_, p) => Text(p.slug),
          width: 180,
        ),
        AdminColumn<PageRow>(
          title: AdminLocalizations.translate(context, 'status'),
          sortable: true,
          sortValue: (p) => p.isActive ? 1 : 0,
          exportValue: (p) => p.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'inactive'),
          cell: (_, p) => AdminStatusBadge(isActive: p.isActive),
          width: 100,
        ),
        AdminColumn<PageRow>(
          title: AdminLocalizations.translate(context, 'actions'),
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
      title: AdminLocalizations.translate(context, 'page details'),
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
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (en)'), page.title, Icons.title_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'title (ar)'), page.titleAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.translate_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'slug'), '/${page.slug}', Icons.link_rounded, bottomPadding: 0)),
            const SizedBox(width: 16),
            Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'status'), page.isActive ? AdminLocalizations.translate(context, 'published') : AdminLocalizations.translate(context, 'draft'), Icons.check_circle_outline_rounded, bottomPadding: 0)),
          ],
        ),
        const SizedBox(height: 20),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'content (en)'), page.content ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_rounded),
        AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'content (ar)'), page.contentAr ?? AdminLocalizations.translate(context, 'n/a'), Icons.description_outlined),
      ],
    );
  }
}
