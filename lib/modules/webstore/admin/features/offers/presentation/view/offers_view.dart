import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_card_popup_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../view_model/offers_view_model.dart';
import '../widgets/offers_table.dart';
import '../widgets/offer_form.dart';
import 'package:erp/modules/webstore/admin/features/offers/data/models/offer_row.dart';

class OffersView extends ConsumerWidget {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(offersVmProvider);
    final notifier = ref.read(offersVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'Offers'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'Add Offer'),
                onPrimaryAction: () => notifier.openAdd(),
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildBody(context, state, isDark, notifier)),
            ],
          ),
        ),
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: state.isAdding || state.editingItem != null,
            onClose: () => notifier.closePanel(),
            title: state.isAdding ? AdminLocalizations.translate(context, 'Create Offer') : AdminLocalizations.translate(context, 'Edit Offer'),
            size: AdminDialogSize.medium,
            child: OfferForm(
              key: ValueKey(state.isAdding ? 'offer-add' : 'offer-edit-${state.editingItem?.id ?? 0}'),
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data, imageFile) async {
                final result = await notifier.commitSave(data, id: state.editingItem?.id, imageFile: imageFile);
                if (!context.mounted) return;

                if (result) {
                  notifier.closePanel();
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: state.isAdding ? AdminLocalizations.translate(context, 'Offer Created') : AdminLocalizations.translate(context, 'Offer Updated'),
                    message: AdminLocalizations.translate(context, 'The offer has been saved successfully.'),
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: AdminLocalizations.translate(context, 'Save Failed'),
                    message: AdminLocalizations.translate(context, 'Could not save the offer. Please try again.'),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<OfferRow> state, bool isDark, OffersVm notifier) {
    return switch (state) {
      AdminCrudLoading() => const Center(child: CircularProgressIndicator()),
      AdminCrudError(:final message) => AdminStateWidget(message: message, onRetry: () => notifier.fetch()),
      AdminCrudData(:final items) => AppAnimation.fadeInUp(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isDark ? const Color(0xFF0F1B2D) : Colors.white,
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: OffersTable(
              items: items,
              onEdit: (c) => notifier.openEdit(c),
              onDelete: (id) => _confirmAndDelete(context, notifier, id, items.firstWhere((c) => c.id == id).name),
              cardBuilder: (context, c) => _OfferCard(
                offer: c,
                onView: () => showDialog(context: context, builder: (_) => OfferDetailsDialog(offer: c)),
                onEdit: () => notifier.openEdit(c),
                onDelete: () => _confirmAndDelete(context, notifier, c.id, c.name),
              ),
            ),
          ),
        ),
    };
  }

  void _confirmAndDelete(BuildContext context, OffersVm notifier, int id, String name) {
    AppDialog.show(
      context,
      title: AdminLocalizations.translate(context, 'Delete Offer'),
      message: '${AdminLocalizations.translate(context, 'Are you sure you want to delete offer')} "$name"?',
      cancelText: AdminLocalizations.translate(context, 'Cancel'),
      confirmText: AdminLocalizations.translate(context, 'Delete'),
      onConfirm: () async {
        Navigator.pop(context);
        final success = await notifier.commitDelete(id);
        if (!context.mounted) return;
        if (success) {
          AppStatusDialog.show(context, status: AppDialogStatus.success, title: AdminLocalizations.translate(context, 'Deleted'), message: AdminLocalizations.translate(context, 'Offer deleted successfully.'));
        } else {
          AppStatusDialog.show(context, status: AppDialogStatus.error, title: AdminLocalizations.translate(context, 'Delete Failed'), message: AdminLocalizations.translate(context, 'Could not delete offer. Please try again.'));
        }
      },
    );
  }
}

class _OfferCard extends StatelessWidget {
  final OfferRow offer;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _OfferCard({
    required this.offer,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        offer.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: theme.primaryColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer.isPercentage ? '${offer.discountValue}% ${AdminLocalizations.translate(context, 'Discount')}' : '\$${offer.discountValue} ${AdminLocalizations.translate(context, 'Off')}',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              AdminCardPopupMenu(
                onView: onView,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdminStatusBadge(isActive: offer.isActive),
              Text(
                '${AdminLocalizations.translate(context, 'ID')}: ${offer.id}',
                style: theme.textTheme.labelSmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
