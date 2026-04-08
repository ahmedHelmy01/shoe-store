import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/modules/webstore/cms/presentation/view/contact_us_view.dart';
import 'package:erp/core/providers/theme_provider.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/providers/core_providers.dart';

class WebStoreMoreView extends ConsumerWidget {
  const WebStoreMoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WebStoreBaseScaffold(
      titleText: LocaleKeys.webstore.nav.more.tr(context: context),
      showAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            20.verticalSpace,
            _buildProfileHeader(context),
            30.verticalSpace,
            _buildSection(
              context: context,
              title: 'webstore.more.appearance'.tr(context: context),
              items: [
                SwitchListTile(
                  secondary: Icon(
                    ref.watch(themeProvider.notifier).isDarkMode 
                        ? Icons.dark_mode_rounded 
                        : Icons.light_mode_rounded,
                    color: AppColors.primaryBlue,
                  ),
                  title: Text(
                    'webstore.more.dark_mode'.tr(context: context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  value: ref.watch(themeProvider.notifier).isDarkMode,
                  onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
                  activeColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                ),
              ],
            ),
            20.verticalSpace,
            _buildSection(
              context: context,
              title: LocaleKeys.common.settings.tr(context: context),
              items: [
                _MoreItem(
                  icon: Icons.receipt_long_rounded,
                  title: 'webstore.more.my_orders'.tr(context: context),
                  onTap: () {
                    AppNavigator.push(context, AppRouteNames.webstoreOrderList);
                  },
                ),
                _MoreItem(
                  icon: Icons.favorite_outline_rounded,
                  title: 'webstore.more.wishlist'.tr(context: context),
                  onTap: () {
                    AppNavigator.push(context, AppRouteNames.webstoreWishlist);
                  },
                ),
                _MoreItem(
                  icon: Icons.stars_rounded,
                  title: 'webstore.more.my_points'.tr(context: context),
                  onTap: () {
                    AppNavigator.push(context, AppRouteNames.webstorePoints);
                  },
                ),
                _MoreItem(
                  icon: Icons.language_rounded,
                  title: (context.locale.languageCode == 'ar'
                          ? LocaleKeys.webstore.more.english
                          : LocaleKeys.webstore.more.arabic)
                      .tr(context: context),
                  onTap: () async {
                    final next = context.locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
                    await ref.read(sessionManagerProvider).setLocale(next.languageCode);
                    if (context.mounted) {
                      await context.setLocale(next);
                    }
                  },
                ),
                _MoreItem(
                  icon: Icons.notifications_none_rounded,
                  title: LocaleKeys.common.notifications.tr(context: context),
                  onTap: () {},
                ),
              ],
            ),
            20.verticalSpace,
            _buildSection(
              context: context,
              title: '',
              items: [
                _MoreItem(
                  icon: Icons.info_outline_rounded,
                  title: LocaleKeys.common.about_us.tr(context: context),
                  onTap: () {
                    // Navigate to about us slug
                  },
                ),
                _MoreItem(
                  icon: Icons.contact_support_outlined,
                  title: LocaleKeys.common.contact_us.tr(context: context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ContactUsView()),
                    );
                  },
                ),
              ],
            ),
            30.verticalSpace,
            _MoreItem(
              icon: Icons.logout_rounded,
              title: LocaleKeys.common.logout.tr(context: context),
              color: AppColors.error,
              showChevron: false,
              onTap: () {},
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35.r,
            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
            child: Icon(Icons.person_rounded, size: 40.r, color: AppColors.primaryBlue),
          ),
          20.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                5.verticalSpace,
                Text(
                  'user@example.com',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required BuildContext context, required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
                letterSpacing: 1,
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _MoreItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final bool showChevron;

  const _MoreItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? AppColors.primaryBlue),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: showChevron 
          ? Icon(Icons.chevron_right_rounded, size: 24.r, color: Theme.of(context).hintColor)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    );
  }
}
