import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/more/presentation/view/widgets/more_profile_header.dart';
import 'package:erp/modules/webstore/more/presentation/view/widgets/more_grid_item.dart';
import 'package:erp/modules/webstore/more/presentation/view/widgets/more_settings_section.dart';
import 'package:erp/modules/webstore/more/presentation/view/widgets/more_auth_button.dart';

class WebStoreMoreView extends ConsumerWidget {
  const WebStoreMoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final isAuthed = auth.status == AuthStatus.authenticated;

    return WebStoreBaseScaffold(
      titleText: LocaleKeys.webstore.nav.more.tr(context: context),
      showAppBar: true,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Profile Header
            AppAnimation.fadeInDown(
              child: MoreProfileHeader(isAuthed: isAuthed),
            ),

            24.verticalSpace,

            // 2. Main Services Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppAnimation.fadeInUp(
                delay: const Duration(milliseconds: 200),
                child: _buildServicesGrid(context, isAuthed),
              ),
            ),

            24.verticalSpace,

            // 3. Settings List
            AppAnimation.fadeInUp(
              delay: const Duration(milliseconds: 400),
              child: const MoreSettingsSection(),
            ),

            32.verticalSpace,

            // 4. Auth Action Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppAnimation.fadeInUp(
                delay: const Duration(milliseconds: 600),
                child: MoreAuthButton(isAuthed: isAuthed),
              ),
            ),

            40.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _checkAuthAndNavigate(
      BuildContext context, bool isAuthed, String route) {
    if (!isAuthed) {
      AppNavigator.push(context, AppRouteNames.webstoreLogin);
    } else {
      AppNavigator.push(context, route);
    }
  }

  Widget _buildServicesGrid(BuildContext context, bool isAuthed) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16.w,
      crossAxisSpacing: 16.w,
      childAspectRatio: 1.3,
      children: [
        MoreGridItem(
          icon: Icons.receipt_long_rounded,
          title: LocaleKeys.webstore.more.my_orders.tr(context: context),
          color: Colors.blue,
          onTap: () => _checkAuthAndNavigate(
              context, isAuthed, AppRouteNames.webstoreOrderList),
        ),
        MoreGridItem(
          icon: Icons.favorite_rounded,
          title: LocaleKeys.webstore.more.wishlist.tr(context: context),
          color: Colors.redAccent,
          onTap: () => _checkAuthAndNavigate(
              context, isAuthed, AppRouteNames.webstoreWishlist),
        ),
        MoreGridItem(
          icon: Icons.stars_rounded,
          title: LocaleKeys.webstore.points.title.tr(context: context),
          color: Colors.amber,
          onTap: () => _checkAuthAndNavigate(
              context, isAuthed, AppRouteNames.webstorePoints),
        ),
        MoreGridItem(
          icon: Icons.notifications_active_rounded,
          title: LocaleKeys.common.notifications.tr(context: context),
          color: Colors.teal,
          onTap: () {},
        ),
      ],
    );
  }
}
