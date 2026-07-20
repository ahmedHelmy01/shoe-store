import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/providers/theme_provider.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/pages/presentation/view_model/pages_view_model.dart';
import 'package:erp/modules/webstore/support/presentation/view/contact_us_view.dart';
import 'package:erp/modules/webstore/support/presentation/view/contact_info_view.dart';

class MoreSettingsSection extends ConsumerWidget {
  const MoreSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pagesState = ref.watch(cmsPagesProvider);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
            color: (isDark ? Colors.white : Colors.black)
                .withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // Language Toggle
          _buildListTile(
            context,
            icon: Icons.language_rounded,
            title: (context.locale.languageCode == 'ar'
                    ? LocaleKeys.webstore.more.english
                    : LocaleKeys.webstore.more.arabic)
                .tr(context: context),
            onTap: () async {
              final next = context.locale.languageCode == 'ar'
                  ? const Locale('en')
                  : const Locale('ar');
              await ref.read(sessionManagerProvider).setLocale(next.languageCode);
              if (context.mounted) await context.setLocale(next);
            },
          ),
          Divider(height: 1, indent: 50.w, endIndent: 20.w),

          // Dark Mode Toggle
          SwitchListTile(
            secondary: Icon(
              ref.watch(themeProvider.notifier).isDarkMode
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: AppColors.primaryBlue,
            ),
            title: Text(
              LocaleKeys.webstore.more.dark_mode.tr(context: context),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            value: ref.watch(themeProvider.notifier).isDarkMode,
            onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
            activeThumbColor: AppColors.primaryOrange,
          ),
          Divider(height: 1, indent: 50.w, endIndent: 20.w),

          // About Us
          _buildListTile(
            context,
            icon: Icons.info_outline_rounded,
            title: LocaleKeys.common.about_us.tr(context: context),
            onTap: () {
              pagesState.whenData((pages) {
                final page = pages.where((p) => p.slug == 'about-us').firstOrNull ?? (pages.isNotEmpty ? pages.first : null);
                if (page != null) {
                  AppNavigator.push(
                    context,
                    AppRouteNames.webstorePage,
                    arguments: {
                      'slug': page.slug,
                      'title': context.locale.languageCode == 'ar'
                          ? page.titleAr
                          : page.title,
                    },
                  );
                }
              });
            },
          ),
          Divider(height: 1, indent: 50.w, endIndent: 20.w),

          // Terms and Conditions
          _buildListTile(
            context,
            icon: Icons.gavel_rounded,
            title:
                LocaleKeys.common.terms_and_conditions.tr(context: context),
            onTap: () {
              pagesState.whenData((pages) {
                final page = pages.where((p) => p.slug == 'terms-and-conditions').firstOrNull ?? (pages.length > 1 ? pages[1] : null);
                if (page != null) {
                  AppNavigator.push(
                    context,
                    AppRouteNames.webstorePage,
                    arguments: {
                      'slug': page.slug,
                      'title': context.locale.languageCode == 'ar'
                          ? page.titleAr
                          : page.title,
                    },
                  );
                }
              });
            },
          ),
          Divider(height: 1, indent: 50.w, endIndent: 20.w),

          // Contact Info (Phone, Email, Social)
          _buildListTile(
            context,
            icon: Icons.headphones_rounded,
            title: LocaleKeys.webstore.more.contact_info.tr(context: context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactInfoView()),
              );
            },
          ),
          Divider(height: 1, indent: 50.w, endIndent: 20.w),

          // Contact Us Form
          _buildListTile(
            context,
            icon: Icons.contact_support_outlined,
            title: LocaleKeys.common.contact_us.tr(context: context),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactUsView()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(title,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
      trailing:
          Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: Colors.grey),
      onTap: onTap,
    );
  }
}
