import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/orders_view_model.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/widgets/order_details_dialog.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/data/models/order_status_row.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/features/users/presentation/view_model/users_view_model.dart';
import 'package:erp/modules/webstore/admin/features/users/data/models/user_row.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';

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
  List<OrderStatusRow>? _statuses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(ordersVmProvider);
    final notifier = ref.read(ordersVmProvider.notifier);
    final usersState = ref.watch(usersVmProvider);

    if ((state.isAdding || state.editingItem != null) && _statuses == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadStatuses());
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminLocalizations.translate(context, 'customer orders'),
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
            onClose: () {
              notifier.closePanel();
              setState(() => _statuses = null);
            },
            title: '${AdminLocalizations.translate(context, 'manage order')} #${state.editingItem?.id}',
            size: AdminDialogSize.large,
            child: _statuses != null
                ? OrderForm(
                    initial: state.editingItem,
                    isSaving: state.isSaving,
                    statuses: _statuses!,
                    onSave: (data) async {
                      final orderId = state.editingItem?.id;
                      if (orderId != null) {
                        final statusId = data['order_status_id'] as int?;
                        if (statusId != null) {
                          final ok = await notifier.updateStatus(orderId, statusId, notes: data['notes'] as String?);
                          if (ok && context.mounted) {
                            notifier.closePanel();
                          }
                        }
                      }
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Future<void> _loadStatuses() async {
    if (_statuses != null) return;
    final res = await ref.read(orderStatusesRepositoryProvider).getAllOrderStatuses();
    if (mounted) {
      setState(() {
        _statuses = res.when(success: (list) => list, failure: (_) => []);
      });
    }
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
          hint: Text(AdminLocalizations.translate(context, 'filter by customer (optional)')),
          value: _selectedCustomerId,
          items: [
            DropdownMenuItem<int>(
              value: null,
              child: Text(AdminLocalizations.translate(context, 'all customers')),
            ),
            ...usersState.items.map((user) {
              return DropdownMenuItem<int>(
                value: user.id,
                child: Text('${user.name} (${user.mobile ?? AdminLocalizations.translate(context, 'no mobile')})'),
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
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(AdminLocalizations.translate(context, 'no orders found for this selection.')),
                ))
              : OrdersTable(
                  items: items,
                  onView: (o) => _showOrderDetails(context, notifier, o.id),
                  onEdit: (o) => notifier.openEdit(o),
                  cardBuilder: (context, o) => OrderCard(
                    order: o,
                    onView: () => _showOrderDetails(context, notifier, o.id),
                    onEdit: () => notifier.openEdit(o),
                  ),
                ),
          ),
        ),
    };
  }

  Future<void> _showOrderDetails(BuildContext context, OrdersVm notifier, int orderId) async {
    final detail = await notifier.getOrderDetails(orderId);
    if (detail != null && context.mounted) {
      showDialog(
        context: context,
        builder: (_) => OrderDetailsDialog(order: detail),
      );
    } else if (context.mounted) {
      AppStatusDialog.show(
        context,
        status: AppDialogStatus.error,
        title: AdminLocalizations.translate(context, 'error'),
        message: AdminLocalizations.translate(context, 'could not load order details.'),
      );
    }
  }
}
