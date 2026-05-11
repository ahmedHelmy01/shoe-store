import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/modules/webstore/support/presentation/view/contact_us_view.dart';
import 'package:erp/core/providers/theme_provider.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/pages/presentation/view_model/pages_view_model.dart';

class WebStoreMoreView extends ConsumerWidget {
  const WebStoreMoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final isAuthed = auth.status == AuthStatus.authenticated;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return WebStoreBaseScaffold(
      titleText: LocaleKeys.webstore.nav.more.tr(context: context),
      showAppBar: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Profile Header
            AppAnimation.fadeInDown(
              child: _buildProfileHeader(context, ref, isAuthed),
            ),
            
            24.verticalSpace,

            // 2. Main Services Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppAnimation.fadeInUp(
                delay: const Duration(milliseconds: 200),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.w,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 1.3,
                  children: [
                    _buildGridItem(
                      context,
                      icon: Icons.receipt_long_rounded,
                      title: 'webstore.more.my_orders'.tr(context: context),
                      color: Colors.blue,
                      onTap: () => _checkAuthAndNavigate(context, isAuthed, AppRouteNames.webstoreOrderList),
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.favorite_rounded,
                      title: 'webstore.more.wishlist'.tr(context: context),
                      color: Colors.redAccent,
                      onTap: () => _checkAuthAndNavigate(context, isAuthed, AppRouteNames.webstoreWishlist),
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.stars_rounded,
                      title: LocaleKeys.webstore.points.title.tr(context: context),
                      color: Colors.amber,
                      onTap: () => _checkAuthAndNavigate(context, isAuthed, AppRouteNames.webstorePoints),
                    ),
                    _buildGridItem(
                      context,
                      icon: Icons.notifications_active_rounded,
                      title: LocaleKeys.common.notifications.tr(context: context),
                      color: Colors.teal,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            24.verticalSpace,

            // 3. Settings List
            AppAnimation.fadeInUp(
              delay: const Duration(milliseconds: 400),
              child: _buildSettingsSection(context, ref),
            ),

            32.verticalSpace,

            // 4. Auth Action Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AppAnimation.fadeInUp(
                delay: const Duration(milliseconds: 600),
                child: _buildAuthButton(context, ref, isAuthed),
              ),
            ),
            
            40.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _checkAuthAndNavigate(BuildContext context, bool isAuthed, String route) {
    if (!isAuthed) {
      AppNavigator.push(context, AppRouteNames.webstoreLogin);
    } else {
      AppNavigator.push(context, route);
    }
  }

  Widget _buildGridItem(BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28.sp),
            ),
            10.verticalSpace,
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pagesState = ref.watch(cmsPagesProvider);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: (theme.brightness == Brightness.dark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          _buildListTile(
            context,
            icon: Icons.language_rounded,
            title: (context.locale.languageCode == 'ar' ? LocaleKeys.webstore.more.english : LocaleKeys.webstore.more.arabic).tr(context: context),
            onTap: () async {
               final next = context.locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
               await ref.read(sessionManagerProvider).setLocale(next.languageCode);
               if (context.mounted) await context.setLocale(next);
            },
          ),
          Divider(height: 1, indent: 50.w, endIndent: 20.w),
          SwitchListTile(
            secondary: Icon(
              ref.watch(themeProvider.notifier).isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: AppColors.primaryBlue,
            ),
            title: Text(
              'webstore.more.dark_mode'.tr(context: context),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            value: ref.watch(themeProvider.notifier).isDarkMode,
            onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
            activeColor: AppColors.primaryOrange,
          ),
          Divider(height: 1, indent: 50.w, endIndent: 20.w),
          
          // About Us (First Page)
          _buildListTile(
            context,
            icon: Icons.info_outline_rounded,
            title: LocaleKeys.common.about_us.tr(context: context),
            onTap: () {
              pagesState.whenData((pages) {
                if (pages.isNotEmpty) {
                  final page = pages.first;
                  AppNavigator.push(
                    context, 
                    AppRouteNames.webstorePage,
                    arguments: {
                      'slug': page.slug,
                      'title': context.locale.languageCode == 'ar' ? page.titleAr : page.title,
                    },
                  );
                }
              });
            },
          ),
          Divider(height: 1, indent: 50.w, endIndent: 20.w),

          // Terms and Conditions (Second Page)
          _buildListTile(
            context,
            icon: Icons.gavel_rounded,
            title: LocaleKeys.common.terms_and_conditions.tr(context: context),
            onTap: () {
              pagesState.whenData((pages) {
                if (pages.length > 1) {
                  final page = pages[1];
                  AppNavigator.push(
                    context, 
                    AppRouteNames.webstorePage,
                    arguments: {
                      'slug': page.slug,
                      'title': context.locale.languageCode == 'ar' ? page.titleAr : page.title,
                    },
                  );
                }
              });
            },
          ),
          Divider(height: 1, indent: 50.w, endIndent: 20.w),

          _buildListTile(
            context,
            icon: Icons.contact_support_outlined,
            title: LocaleKeys.common.contact_us.tr(context: context),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsView()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildAuthButton(BuildContext context, WidgetRef ref, bool isAuthed) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: isAuthed 
            ? [const Color(0xFFFF5252), const Color(0xFFFF1744)]
            : [AppColors.primaryOrange, const Color(0xFFFF8C00)],
        ),
        boxShadow: [
          BoxShadow(
            color: (isAuthed ? Colors.red : AppColors.primaryOrange).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        onPressed: () => isAuthed ? _handleLogout(context, ref) : AppNavigator.push(context, AppRouteNames.webstoreLogin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isAuthed ? Icons.logout_rounded : Icons.login_rounded, color: Colors.white),
            12.horizontalSpace,
            Text(
              isAuthed ? LocaleKeys.common.logout.tr(context: context) : LocaleKeys.webstore.auth.login_or_register.tr(context: context),
              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    AppStatusDialog.show(
      context,
      status: AppDialogStatus.error,
      title: LocaleKeys.webstore.auth.logout_title.tr(context: context),
      message: LocaleKeys.webstore.auth.logout_confirm.tr(context: context),
      actionText: LocaleKeys.webstore.auth.logout_button.tr(context: context),
      onActionPressed: () async {
        await ref.read(sessionManagerProvider).clearSession();
        ref.read(authStateProvider.notifier).setUnauthenticated();
        if (context.mounted) {
          AppNavigator.replace(context, AppRouteNames.webstoreMain);
        }
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, WidgetRef ref, bool isAuthed) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isAuthed 
            ? [AppColors.primaryBlue, const Color(0xFF1E3A8A)]
            : [theme.cardColor, theme.cardColor],
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
            ),
            child: CircleAvatar(
              radius: 35.r,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              child: Icon(Icons.person_rounded, size: 40.r, color: isAuthed ? Colors.white : AppColors.primaryBlue),
            ),
          ),
          20.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAuthed ? LocaleKeys.webstore.auth.welcome_back.tr(context: context) : LocaleKeys.webstore.auth.guest_title.tr(context: context),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isAuthed ? Colors.white : theme.textTheme.bodyLarge?.color,
                  ),
                ),
                4.verticalSpace,
                Text(
                  isAuthed ? LocaleKeys.webstore.auth.welcome_family.tr(context: context) : LocaleKeys.webstore.auth.guest_subtitle.tr(context: context),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isAuthed ? Colors.white.withValues(alpha: 0.8) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
