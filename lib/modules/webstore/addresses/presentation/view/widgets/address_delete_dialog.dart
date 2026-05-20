import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/modules/webstore/addresses/data/models/address_model.dart';
import 'package:erp/modules/webstore/addresses/presentation/view_model/address_providers.dart';

abstract final class AddressDeleteDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    AddressModel address,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف العنوان'),
        content: const Text('هل أنت متأكد من رغبتك في حذف عنوان التوصيل هذا؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (address.id == null) return;

              final error = await ref
                  .read(addressesProvider.notifier)
                  .deleteAddress(address.id!);

              if (!context.mounted) return;

              if (error != null) {
                await AppStatusDialog.showError(
                  context,
                  title: 'تعذّر حذف العنوان',
                  message: error,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف العنوان بنجاح')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
