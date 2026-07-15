import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
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
    final keys = LocaleKeys.webstore.addresses;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(keys.delete_title.tr(context: context)),
        content: Text(keys.delete_confirm.tr(context: context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(LocaleKeys.common.cancel.tr(context: context)),
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
                  title: keys.delete_failed_title.tr(context: context),
                  message: error,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(keys.deleted_success.tr(context: context)),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              LocaleKeys.common.delete.tr(context: context),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
