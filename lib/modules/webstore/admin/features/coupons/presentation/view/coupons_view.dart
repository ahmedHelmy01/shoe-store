import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import '../view_model/coupons_view_model.dart';
import '../widgets/coupons_table.dart';
import '../widgets/coupon_form.dart';
import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';

class CouponsView extends ConsumerWidget {
  const CouponsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(couponsVmProvider);
    final notifier = ref.read(couponsVmProvider.notifier);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: 'Discount Coupons',
                onRefresh: () => notifier.fetch(),
                primaryActionLabel: 'Add Coupon',
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
            title: state.isAdding ? 'Create Coupon' : 'Edit Coupon',
            size: AdminDialogSize.medium,
            child: CouponForm(
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                if (await notifier.commitSave(data, id: state.editingItem?.id)) {
                  notifier.closePanel();
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<CouponRow> state, bool isDark, CouponsVm notifier) {
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
            child: CouponsTable(
              items: items,
              onEdit: (c) => notifier.openEdit(c),
              onDelete: (id) => notifier.commitDelete(id),
              cardBuilder: (context, c) => _CouponCard(
                coupon: c,
                onEdit: () => notifier.openEdit(c),
                onDelete: () => notifier.commitDelete(c.id),
              ),
            ),
          ),
        ),
    };
  }
}

class _CouponCard extends StatelessWidget {
  final CouponRow coupon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CouponCard({
    required this.coupon,
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
                        coupon.code,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: theme.primaryColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      coupon.isPercentage ? '${coupon.discountAmount}% Discount' : '\$${coupon.discountAmount} Off',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID: ${coupon.id}',
                style: theme.textTheme.labelSmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
