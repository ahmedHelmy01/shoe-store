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
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../view_model/sliders_view_model.dart';
import '../widgets/sliders_table.dart';
import '../widgets/slider_form.dart';
import 'package:erp/modules/webstore/admin/features/sliders/data/models/slider_row.dart';

class SlidersView extends ConsumerWidget {
  const SlidersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(slidersVmProvider);
    final notifier = ref.read(slidersVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'homepage sliders'),
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: AdminLocalizations.translate(context, 'add slider'),
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
            title: state.isAdding ? AdminLocalizations.translate(context, 'create slider') : AdminLocalizations.translate(context, 'edit slider'),
            size: AdminDialogSize.medium,
            child: SliderForm(
              key: ValueKey(state.isAdding ? 'slider-add' : 'slider-edit-${state.editingItem?.id ?? 0}'),
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
                    title: state.isAdding ? AdminLocalizations.translate(context, 'slider created') : AdminLocalizations.translate(context, 'slider updated'),
                    message: AdminLocalizations.translate(context, 'the slider has been saved successfully.'),
                  );
                } else {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.error,
                    title: AdminLocalizations.translate(context, 'save failed'),
                    message: AdminLocalizations.translate(context, 'could not save the slider. please try again.'),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<SliderRow> state, bool isDark, SlidersVm notifier) {
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
            child: SlidersTable(
              items: items,
              onEdit: (s) => notifier.openEdit(s),
              onDelete: (id) => _confirmAndDelete(context, notifier, id, items.firstWhere((s) => s.id == id).title),
              cardBuilder: (context, s) => _SliderCard(
                slider: s,
                onView: () => showDialog(context: context, builder: (_) => SliderDetailsDialog(slider: s)),
                onEdit: () => notifier.openEdit(s),
                onDelete: () => _confirmAndDelete(context, notifier, s.id, s.title),
              ),
            ),
          ),
        ),
    };
  }

  void _confirmAndDelete(BuildContext context, SlidersVm notifier, int id, String title) {
    AppDialog.show(
      context,
      title: AdminLocalizations.translate(context, 'delete slider'),
      message: '${AdminLocalizations.translate(context, 'are you sure you want to delete')} "$title"?',
      cancelText: AdminLocalizations.translate(context, 'cancel'),
      confirmText: AdminLocalizations.translate(context, 'delete'),
      onConfirm: () async {
        Navigator.pop(context);
        final success = await notifier.commitDelete(id);
        if (!context.mounted) return;
        if (success) {
          AppStatusDialog.show(context, status: AppDialogStatus.success, title: AdminLocalizations.translate(context, 'deleted'), message: AdminLocalizations.translate(context, 'slider deleted successfully.'));
        } else {
          AppStatusDialog.show(context, status: AppDialogStatus.error, title: AdminLocalizations.translate(context, 'delete failed'), message: AdminLocalizations.translate(context, 'could not delete slider.'));
        }
      },
    );
  }
}


class _SliderCard extends StatelessWidget {
  final SliderRow slider;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SliderCard({
    required this.slider,
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
                    Text(
                      slider.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slider.titleAr ?? AdminLocalizations.translate(context, 'no arabic title'),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: (slider.isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
                ),
                child: Text(
                  slider.isActive ? AdminLocalizations.translate(context, 'active') : AdminLocalizations.translate(context, 'disabled'),
                  style: theme.textTheme.labelSmall?.copyWith(color: slider.isActive ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${AdminLocalizations.translate(context, 'id')}: ${slider.id}',
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
