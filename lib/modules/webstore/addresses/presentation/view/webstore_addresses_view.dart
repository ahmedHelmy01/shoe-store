import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/addresses/presentation/view_model/address_providers.dart';
import 'package:erp/modules/webstore/addresses/presentation/view/widgets/address_delete_dialog.dart';
import 'package:erp/modules/webstore/addresses/presentation/view/widgets/addresses_add_fab.dart';
import 'package:erp/modules/webstore/addresses/presentation/view/widgets/addresses_empty_view.dart';
import 'package:erp/modules/webstore/addresses/presentation/view/widgets/addresses_list_view.dart';
import 'package:erp/modules/webstore/addresses/presentation/view/widgets/addresses_load_error_view.dart';

class WebStoreAddressesView extends ConsumerStatefulWidget {
  const WebStoreAddressesView({super.key});

  @override
  ConsumerState<WebStoreAddressesView> createState() =>
      _WebStoreAddressesViewState();
}

class _WebStoreAddressesViewState extends ConsumerState<WebStoreAddressesView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final async = ref.watch(addressesProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(titleText: 'webstore.addresses.title'.tr(context: context)),
      floatingActionButton: AddressesAddFab(
        onPressed: () =>
            AppNavigator.push(context, AppRouteNames.webstoreAddEditAddress),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(addressesProvider.notifier).refresh(),
        child: async.when(
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (err, _) => AddressesLoadErrorView(
            error: err,
            onRetry: () => ref.read(addressesProvider.notifier).refresh(),
          ),
          data: (addresses) {
            if (addresses.isEmpty) return const AddressesEmptyView();
            return AddressesListView(
              addresses: addresses,
              isDark: isDark,
              onEdit: (a) => AppNavigator.push(
                context,
                AppRouteNames.webstoreAddEditAddress,
                arguments: a,
              ),
              onDelete: (a) => AddressDeleteDialog.show(context, ref, a),
              onSetDefault: (a) =>
                  ref.read(addressesProvider.notifier).toggleDefault(a),
            );
          },
        ),
      ),
    );
  }
}
