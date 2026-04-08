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

class WebStoreMoreView extends ConsumerWidget {
  const WebStoreMoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WebStoreBaseScaffold(
      titleText: LocaleKeys.webstore.nav.more.tr(),
      showAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            20.verticalSpace,
            _buildProfileHeader(context),
            30.verticalSpace,
            _buildSection(
              context: context,
              title: 'webstore.more.appearance'.tr(),
              items: [
                SwitchListTile(
                  secondary: Icon(
                    ref.watch(themeProvider.notifier).isDarkMode 
                        ? Icons.dark_mode_rounded 
                        : Icons.light_mode_rounded,
                    color: AppColors.primaryBlue,
                  ),
                  title: Text(
                    'webstore.more.dark_mode'.tr(),
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
              title: LocaleKeys.common.settings.tr(),
              items: [
                _MoreItem(
                  icon: Icons.receipt_long_rounded,
                  title: 'webstore.more.my_orders'.tr(),
                  onTap: () {
                    AppNavigator.push(context, AppRouteNames.webstoreOrderList);
                  },
                ),
                _MoreItem(
                  icon: Icons.favorite_outline_rounded,
                  title: 'webstore.more.wishlist'.tr(),
                  onTap: () {
                    AppNavigator.push(context, AppRouteNames.webstoreWishlist);
                  },
                ),
                _MoreItem(
                  icon: Icons.stars_rounded,
                  title: 'webstore.more.my_points'.tr(),
                  onTap: () {
                    AppNavigator.push(context, AppRouteNames.webstorePoints);
                  },
                ),
                _MoreItem(
                  icon: Icons.language_rounded,
                  title: context.locale.languageCode == 'ar' ? 'English' : 'العربية',
                  onTap: () {
                    if (context.locale.languageCode == 'ar') {
                      context.setLocale(const Locale('en'));
                    } else {
                      context.setLocale(const Locale('ar'));
                    }
                  },
                ),
                _MoreItem(
                  icon: Icons.notifications_none_rounded,
                  title: LocaleKeys.common.notifications.tr(),
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
                  title: LocaleKeys.common.about_us.tr(),
                  onTap: () {
                    // Navigate to about us slug
                  },
                ),
                _MoreItem(
                  icon: Icons.contact_support_outlined,
                  title: LocaleKeys.common.contact_us.tr(),
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
              title: LocaleKeys.common.logout.tr(),
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
