import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/orders_view_model.dart';
import 'package:erp/modules/webstore/admin/features/users/presentation/view_model/users_view_model.dart';
import 'package:erp/modules/webstore/admin/features/users/data/models/user_row.dart';

import 'widgets/orders_table.dart';
import 'widgets/order_form.dart';
import 'widgets/order_card.dart';

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({super.key});

  @override
  ConsumerState<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  int? _selectedCustomerId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(ordersVmProvider);
    final notifier = ref.read(ordersVmProvider.notifier);
    final usersState = ref.watch(usersVmProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: 'Customer Orders',
                onRefresh: () => notifier.fetch(),
              ),
              const SizedBox(height: 16),
              
              _buildCustomerSelector(usersState, notifier),
              
              const SizedBox(height: 24),
              Expanded(child: _buildBody(context, state, isDark, notifier)),
            ],
          ),
        ),
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: state.editingItem != null,
            onClose: () => notifier.closePanel(),
            title: 'Manage Order #${state.editingItem?.id}',
            size: AdminDialogSize.large,
            child: OrderForm(
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

  Widget _buildCustomerSelector(AdminCrudState<UserRow> usersState, OrdersVm notifier) {
    if (usersState is! AdminCrudData<UserRow>) {
      return const CircularProgressIndicator();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          hint: const Text('Filter by Customer (Optional)'),
          value: _selectedCustomerId,
          items: [
            const DropdownMenuItem<int>(
              value: null,
              child: Text('All Customers'),
            ),
            ...usersState.items.map((user) {
              return DropdownMenuItem<int>(
                value: user.id,
                child: Text('${user.name} (${user.mobile ?? "No Mobile"})'),
              );
            }),
          ],
          onChanged: (val) {
            setState(() => _selectedCustomerId = val);
            notifier.setCustomerId(val);
            notifier.fetch();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<OrderRow> state, bool isDark, OrdersVm notifier) {
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
            child: items.isEmpty 
              ? const Center(child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text('No orders found for this selection.'),
                ))
              : OrdersTable(
                  items: items,
                  onEdit: (o) => notifier.openEdit(o),
                  onDelete: (id) => notifier.commitDelete(id),
                  cardBuilder: (context, o) => OrderCard(
                    order: o,
                    onEdit: () => notifier.openEdit(o),
                    onDelete: () => notifier.commitDelete(o.id),
                  ),
                ),
          ),
        ),
    };
  }
}
