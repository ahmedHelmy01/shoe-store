import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_details_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/offers/data/models/offer_row.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class OffersTable extends StatelessWidget {
  final List<OfferRow> items;
  final Function(OfferRow c) onEdit;
  final Function(int id) onDelete;
  final Widget Function(BuildContext context, OfferRow c)? cardBuilder;

  const OffersTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AdminDataTable<OfferRow>(
      rows: items,
      idOf: (c) => '${c.id}',
      exportBaseName: 'offers',
      searchHint: AdminLocalizations.translate(context, 'Search offers by name…'),
      searchText: (c) => '${c.id} ${c.name}',
      cardBuilder: cardBuilder,
      columns: [
        AdminColumn<OfferRow>(
          title: AdminLocalizations.translate(context, 'ID'),
          sortable: true,
          sortValue: (c) => c.id,
          exportValue: (c) => '${c.id}',
          cell: (_, c) => Text('${c.id}'),
          width: 80,
        ),
        AdminColumn<OfferRow>(
          title: AdminLocalizations.translate(context, 'Name'),
          sortable: true,
          sortValue: (c) => c.name,
          exportValue: (c) => c.name,
          cell: (_, c) => Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          width: 200,
        ),
        AdminColumn<OfferRow>(
          title: AdminLocalizations.translate(context, 'Discount'),
          sortable: true,
          sortValue: (c) => c.discountValue,
          exportValue: (c) => c.isPercentage ? '${c.discountValue}%' : '\$${c.discountValue}',
          cell: (_, c) => Text(
            c.isPercentage ? '${c.discountValue}%' : '\$${c.discountValue}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          width: 120,
        ),

        AdminColumn<OfferRow>(
          title: AdminLocalizations.translate(context, 'Status'),
          sortable: true,
          sortValue: (c) => c.isActive ? 1 : 0,
          exportValue: (c) => c.isActive ? AdminLocalizations.translate(context, 'Active') : AdminLocalizations.translate(context, 'Inactive'),
          cell: (_, c) => AdminStatusBadge(isActive: c.isActive),
          width: 100,
        ),
        AdminColumn<OfferRow>(
          title: AdminLocalizations.translate(context, 'Actions'),
          cell: (_, c) => AdminTableActionsCell<OfferRow>(
            row: c,
            onView: (c) {
              showDialog(
                context: context,
                builder: (_) => OfferDetailsDialog(offer: c),
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

class OfferDetailsDialog extends ConsumerWidget {
  final OfferRow offer;
  const OfferDetailsDialog({super.key, required this.offer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final singleOfferAsync = ref.watch(singleOfferProvider(offer.id));
    final allProductsAsync = ref.watch(allProductsProvider);

    return singleOfferAsync.when(
      loading: () => AdminDetailsDialog(
        title: AdminLocalizations.translate(context, 'Offer Details'),
        id: offer.id.toString(),
        icon: Icons.local_offer_rounded,
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
      error: (err, _) => AdminDetailsDialog(
        title: AdminLocalizations.translate(context, 'Offer Details'),
        id: offer.id.toString(),
        icon: Icons.local_offer_rounded,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text('${AdminLocalizations.translate(context, "Failed to load details")}: $err'),
            ),
          ),
        ],
      ),
      data: (detailedOffer) {
        return AdminDetailsDialog(
          title: AdminLocalizations.translate(context, 'Offer Details'),
          id: detailedOffer.id.toString(),
          icon: Icons.local_offer_rounded,
          children: [
            if (detailedOffer.imageUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    detailedOffer.imageUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Name (EN)'), detailedOffer.name, Icons.text_fields_rounded, bottomPadding: 0)),
                const SizedBox(width: 16),
                Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Name (AR)'), detailedOffer.nameAr ?? '-', Icons.text_fields_rounded, bottomPadding: 0)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Description (EN)'), detailedOffer.description ?? '-', Icons.description_rounded, bottomPadding: 0)),
                const SizedBox(width: 16),
                Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Description (AR)'), detailedOffer.descriptionAr ?? '-', Icons.description_rounded, bottomPadding: 0)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Discount Type'), AdminLocalizations.translate(context, detailedOffer.discountType), Icons.category_rounded, bottomPadding: 0)),
                const SizedBox(width: 16),
                Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Discount Value'), detailedOffer.isPercentage ? '${detailedOffer.discountValue}%' : '\$${detailedOffer.discountValue}', Icons.discount_rounded, bottomPadding: 0)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'Start Date'), detailedOffer.startDate ?? 'N/A', Icons.event_rounded, bottomPadding: 0)),
                const SizedBox(width: 16),
                Expanded(child: AdminDetailsDialog.buildDetailRow(context, AdminLocalizations.translate(context, 'End Date'), detailedOffer.endDate ?? 'N/A', Icons.event_busy_rounded, bottomPadding: 0)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.shopping_bag_rounded, size: 20, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text('${AdminLocalizations.translate(context, 'Products')} (${detailedOffer.products.length})', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            allProductsAsync.when(
              loading: () => const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
              error: (e, _) => Padding(padding: const EdgeInsets.all(16), child: Text('${AdminLocalizations.translate(context, 'Failed to load products')}: $e')),
              data: (allProducts) {
                final productMap = {for (final p in allProducts) p.id: p};
                if (detailedOffer.products.isEmpty) {
                  return Padding(padding: const EdgeInsets.all(16), child: Text(AdminLocalizations.translate(context, 'No products assigned')));
                }
                return SizedBox(
                  height: 90,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: detailedOffer.products.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final op = detailedOffer.products[index];
                        final product = productMap[op.productId];
                        final hasImage = product?.imageUrl != null;
                        return Container(
                          width: 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.grey.shade50,
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Product image
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(13)),
                                child: Container(
                                  width: 80,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.04)
                                      : Colors.grey.shade100,
                                  child: hasImage
                                      ? Image.network(
                                          product!.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => Center(
                                            child: Icon(Icons.inventory_2_rounded, size: 24, color: theme.primaryColor.withValues(alpha: 0.4)),
                                          ),
                                        )
                                      : Center(
                                          child: Icon(Icons.inventory_2_rounded, size: 24, color: theme.primaryColor.withValues(alpha: 0.4)),
                                        ),
                                ),
                              ),
                              // Product info
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product?.name ?? 'Product #${op.productId}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (product?.salePrice != null) ...[
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: theme.primaryColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '${product!.salePrice} EGP',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            AdminDetailsDialog.buildStatusRow(context, detailedOffer.isActive),
          ],
        );
      },
    );
  }
}
