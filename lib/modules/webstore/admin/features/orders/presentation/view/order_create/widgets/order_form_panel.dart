import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view_model/order_create_view_model.dart';

const _kPayments = ['Cash', 'Card', 'InstaPay'];

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
            'بيانات الطلب',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          AppDropdown<int>(
            label: 'العميل',
            hint: 'اختر العميل',
            value: b.customerId,
            borderRadius: 12,
            items: b.customers
                .map((u) => DropdownMenuItem(
                      value: u.id,
                      child: Text('${u.name} — ${u.mobile ?? u.email ?? '—'}'),
                    ))
                .toList(),
            onChanged: b.onCustomerChanged,
          ),
          const SizedBox(height: 10),
          AppDropdown<String>(
            label: 'عنوان التوصيل',
            hint: 'اختر العنوان بعد اختيار العميل',
            enabled: b.customerId != null,
            value: b.addressLine != null && b.addressChoices.contains(b.addressLine) ? b.addressLine : null,
            borderRadius: 12,
            items: b.addressChoices.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
            onChanged: b.customerId == null ? null : b.onAddressChanged,
          ),
          const SizedBox(height: 10),
          AppDropdown<String>(
            label: 'طريقة الدفع',
            value: b.payment,
            borderRadius: 12,
            items: _kPayments.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) {
              if (v != null) b.onPaymentChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
