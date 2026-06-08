import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/orders/presentation/view_model/orders_providers.dart';
import 'package:erp/modules/webstore/orders/presentation/view/widgets/webstore_order_card_widget.dart';

class WebStoreOrderListView extends ConsumerStatefulWidget {
  const WebStoreOrderListView({super.key});

  @override
  ConsumerState<WebStoreOrderListView> createState() => _WebStoreOrderListViewState();
}

class _WebStoreOrderListViewState extends ConsumerState<WebStoreOrderListView> {
  @override
  void initState() {
    super.initState();
    // Invalidate the provider when entering the screen to ensure fresh data
    Future.microtask(() => ref.invalidate(ordersListProvider));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ordersAsync = ref.watch(ordersListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(titleText: LocaleKeys.webstore.orders.title.tr(context: context)),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(
          child: AppErrorWidget(
            errorMessage: err.toString(),
            onRetry: () => ref.invalidate(ordersListProvider),
          ),
        ),
        data: (response) {
          final rawData = response['data'];
          final List<dynamic> orders;
          if (rawData is Map) {
            orders = rawData['data'] as List? ?? [];
          } else if (rawData is List) {
            orders = rawData;
          } else {
            orders = [];
          }

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64.sp, color: theme.hintColor),
                  16.verticalSpace,
                  Text(
                    LocaleKeys.webstore.orders.title.tr(context: context),
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  8.verticalSpace,
                  Text(
                    LocaleKeys.common.no_orders_yet.tr(context: context),
                    style: TextStyle(fontSize: 14.sp, color: theme.hintColor),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(ordersListProvider);
            },
            child: ListView.separated(
              padding: EdgeInsets.all(20.w),
              itemCount: orders.length,
              separatorBuilder: (context, index) => 16.verticalSpace,
              itemBuilder: (context, index) {
                final order = orders[index] as Map<String, dynamic>;
                return AppAnimation.fadeInUp(
                  delay: Duration(milliseconds: index * 80),
                  child: WebStoreOrderCardWidget(
                    order: order,
                    isDark: isDark,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
