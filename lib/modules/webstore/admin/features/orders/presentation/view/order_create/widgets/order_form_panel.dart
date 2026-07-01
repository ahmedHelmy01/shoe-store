import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/order_create_view_model.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

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
            AdminLocalizations.translate(context, 'order information'),
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          AppDropdown<int>(
            label: AdminLocalizations.translate(context, 'customer'),
            hint: AdminLocalizations.translate(context, 'select customer'),
            value: b.customerId,
            borderRadius: 12,
            items: b.customers
                .map((u) => DropdownMenuItem(
                      value: u.id,
                      child: Text('${u.name} (${u.mobile ?? AdminLocalizations.translate(context, 'no mobile')})'),
                    ))
                .toList(),
            onChanged: b.onCustomerChanged,
          ),
          const SizedBox(height: 10),
          AppDropdown<int>(
            label: AdminLocalizations.translate(context, 'delivery address'),
            hint: b.customerId == null ? AdminLocalizations.translate(context, 'select customer first') : AdminLocalizations.translate(context, 'select address'),
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
            label: AdminLocalizations.translate(context, 'payment method'),
            hint: AdminLocalizations.translate(context, 'select payment method'),
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
