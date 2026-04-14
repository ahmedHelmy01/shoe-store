import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
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
              // Header
              AdminPageHeader(
                title: 'Homepage Sliders',
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: 'Add Slider',
                onPrimaryAction: () => notifier.openAdd(),
              ),
              const SizedBox(height: 20),
              
              // Body
              Expanded(
                child: _buildBody(context, state, isDark, ref),
              ),
            ],
          ),
        ),

        // Side Panel for Add/Edit
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: state.isAdding || state.editingItem != null,
            onClose: () => notifier.closePanel(),
            title: state.isAdding ? 'Create Slider' : 'Edit Slider',
            size: AdminDialogSize.medium,
            child: SliderForm(
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                final success = await notifier.commitSave(data, id: state.editingItem?.id);
                if (success) {
                  notifier.closePanel();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Slider saved successfully'), backgroundColor: Colors.green),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<SliderRow> state, bool isDark, WidgetRef ref) {
    final notifier = ref.read(slidersVmProvider.notifier);

    return switch (state) {
      AdminCrudLoading() => const Center(child: CircularProgressIndicator()),
      AdminCrudError(:final message) => AdminStateWidget(message: message, onRetry: () => notifier.fetch()),
      AdminCrudData(:final items) => AppAnimation.fadeInUp(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
            ),
            child: SlidersTable(
              items: items,
              onEdit: (s) => notifier.openEdit(s),
              onDelete: (id) => _showDeleteDialog(context, id, notifier),
              cardBuilder: (context, s) => _SliderCard(
                slider: s,
                onEdit: () => notifier.openEdit(s),
                onDelete: () => _showDeleteDialog(context, s.id, notifier),
              ),
            ),
          ),
        ),
    };
  }

  void _showDeleteDialog(BuildContext context, int id, SlidersVm notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Slider?'),
        content: const Text('Are you sure you want to remove this slider?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              notifier.commitDelete(id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SliderCard extends StatelessWidget {
  final SliderRow slider;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SliderCard({
    required this.slider,
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
                      slider.titleAr ?? 'No Arabic Title',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: onEdit,
                    child: const Row(children: [Icon(Icons.edit_outlined), SizedBox(width: 8), Text('Edit')]),
                  ),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: const Row(children: [Icon(Icons.delete_outline_rounded, color: Colors.red), SizedBox(width: 8), Text('Delete')]),
                  ),
                ],
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
                  slider.isActive ? 'Active' : 'Disabled',
                  style: theme.textTheme.labelSmall?.copyWith(color: slider.isActive ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'ID: ${slider.id}',
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
