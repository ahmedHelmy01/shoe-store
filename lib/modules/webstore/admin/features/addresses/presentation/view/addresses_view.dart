import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_dialog_form.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/features/users/presentation/view_model/users_view_model.dart';
import 'package:erp/modules/webstore/admin/features/users/data/models/user_row.dart';
import '../view_model/addresses_view_model.dart';
import '../widgets/addresses_table.dart';
import '../widgets/address_form.dart';
import 'package:erp/modules/webstore/admin/features/addresses/data/models/address_row.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class AddressesView extends ConsumerStatefulWidget {
  final int? customerId;
  final String? customerName;

  const AddressesView({
    super.key,
    this.customerId,
    this.customerName,
  });

  @override
  ConsumerState<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends ConsumerState<AddressesView> {
  int? _selectedCustomerId;
  String? _selectedCustomerName;

  @override
  void initState() {
    super.initState();
    _selectedCustomerId = widget.customerId;
    _selectedCustomerName = widget.customerName;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedCustomerId != null) {
        ref.read(addressesVmProvider.notifier).setCustomerId(_selectedCustomerId!);
        ref.read(addressesVmProvider.notifier).fetch();
      }
    });
  }

  void _onCustomerSelected(UserRow? user) {
    if (user == null) return;
    setState(() {
      _selectedCustomerId = user.id;
      _selectedCustomerName = user.name;
    });
    ref.read(addressesVmProvider.notifier).setCustomerId(user.id);
    ref.read(addressesVmProvider.notifier).fetch();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressesVmProvider);
    final notifier = ref.read(addressesVmProvider.notifier);
    final usersState = ref.watch(usersVmProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: _selectedCustomerName != null 
                    ? '${AdminLocalizations.translate(context, 'Addresses')}: $_selectedCustomerName'
                    : AdminLocalizations.translate(context, 'Manage Addresses'),
                onRefresh: _selectedCustomerId == null ? null : () => notifier.fetch(),
                primaryActionLabel: _selectedCustomerId == null ? null : AdminLocalizations.translate(context, 'Add Address'),
                onPrimaryAction: _selectedCustomerId == null ? null : () => notifier.openAdd(),
              ),
              const SizedBox(height: 24),
              
              // Customer Selector (Visible when no customer is passed from constructor)
              if (widget.customerId == null) ...[
                _buildCustomerSelector(usersState),
                const SizedBox(height: 24),
              ],

              Expanded(
                child: _selectedCustomerId == null
                    ? Center(child: Text(AdminLocalizations.translate(context, 'Please select a customer to view and manage addresses.')))
                    : _buildBody(context, state, notifier),
              ),
            ],
          ),
        ),
        if (state.isAdding || state.editingItem != null)
          AdminDialogForm(
            isOpen: true,
            onClose: () => notifier.closePanel(),
            title: state.isAdding ? AdminLocalizations.translate(context, 'New Address') : AdminLocalizations.translate(context, 'Edit Address'),
            child: AddressForm(
              initial: state.editingItem,
              isSaving: state.isSaving,
              onSave: (data) async {
                final result = await notifier.commitSave(data, id: state.editingItem?.id);
                if (result && context.mounted) {
                  notifier.closePanel();
                  AppStatusDialog.show(context, status: AppDialogStatus.success, title: AdminLocalizations.translate(context, 'Success'), message: AdminLocalizations.translate(context, 'Address saved successfully'));
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCustomerSelector(AdminCrudState<UserRow> usersState) {
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
          hint: Text(AdminLocalizations.translate(context, 'Select a Customer')),
          value: _selectedCustomerId,
          items: usersState.items.map((user) {
            return DropdownMenuItem<int>(
              value: user.id,
              child: Text('${user.name} (${user.mobile ?? AdminLocalizations.translate(context, "No Mobile")})'),
            );
          }).toList(),
          onChanged: (val) {
            final user = usersState.items.firstWhere((u) => u.id == val);
            _onCustomerSelected(user);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AdminCrudState<AddressRow> state, AddressesVm notifier) {
    return switch (state) {
      AdminCrudLoading() => const Center(child: CircularProgressIndicator()),
      AdminCrudError(:final message) => AdminStateWidget(message: message, onRetry: () => notifier.fetch()),
      AdminCrudData(:final items) => items.isEmpty 
          ? Center(child: Text(AdminLocalizations.translate(context, 'No addresses found for this customer.')))
          : AddressesTable(
              items: items,
              onEdit: (a) => notifier.openEdit(a),
              onDelete: (id) async {
                final success = await notifier.commitDelete(id);
                if (success && context.mounted) {
                  AppStatusDialog.show(
                    context,
                    status: AppDialogStatus.success,
                    title: AdminLocalizations.translate(context, 'Deleted'),
                    message: AdminLocalizations.translate(context, 'Address deleted successfully'),
                  );
                }
              },
            ),
    };
  }
}
