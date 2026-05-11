import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/order_create_view_model.dart';

class OrderFormPanel extends StatelessWidget {
  final OrderCreateVm b;
  final ThemeData theme;

  const OrderFormPanel({
    super.key,
    required this.b,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Order Information',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          AppDropdown<int>(
            label: 'Customer',
            hint: 'Select Customer',
            value: b.customerId,
            borderRadius: 12,
            items: b.customers
                .map((u) => DropdownMenuItem(
                      value: u.id,
                      child: Text('${u.name} (${u.mobile ?? "No Mobile"})'),
                    ))
                .toList(),
            onChanged: b.onCustomerChanged,
          ),
          const SizedBox(height: 10),
          AppDropdown<int>(
            label: 'Delivery Address',
            hint: b.customerId == null ? 'Select customer first' : 'Select Address',
            enabled: b.customerId != null && b.addressChoices.isNotEmpty,
            value: b.addressId,
            borderRadius: 12,
            items: b.addressChoices
                .map((a) => DropdownMenuItem(
                      value: a.id,
                      child: Text('${a.name}: ${a.addressDetails}'),
                    ))
                .toList(),
            onChanged: b.onAddressChanged,
          ),
          const SizedBox(height: 10),
          AppDropdown<int>(
            label: 'Payment Method',
            hint: 'Select Payment Method',
            value: b.paymentMethodId,
            borderRadius: 12,
            items: b.paymentMethods
                .map((pm) => DropdownMenuItem(
                      value: pm.id,
                      child: Text(pm.name),
                    ))
                .toList(),
            onChanged: b.onPaymentChanged,
          ),
        ],
      ),
    );
  }
}
