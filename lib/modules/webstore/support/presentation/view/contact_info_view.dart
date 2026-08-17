import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_shimmer/app_shimmer.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/utils/open_launcher.dart';
import 'package:erp/modules/webstore/settings/store_settings_provider.dart';

class ContactInfoView extends ConsumerWidget {
  const ContactInfoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(storeSettingsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CommonAppBar(
        titleText: LocaleKeys.webstore.more.contact_info.tr(context: context),
        showBackButton: true,
        onPressBack: () => Navigator.pop(context),
      ),
      body: settingsAsync.when(
        loading: () => _buildShimmer(theme, isDark),
        error: (e, _) => _buildError(context, theme, isDark, () => ref.invalidate(storeSettingsProvider)),
        data: (settings) {
          if (settings == null) return _buildError(context, theme, isDark, () => ref.invalidate(storeSettingsProvider));
          return _buildContent(context, theme, isDark, settings);
        },
      ),
    );
  }

  Widget _buildShimmer(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          AppShimmer.box(width: 120.w, height: 120.w, borderRadius: 60.r),
          SizedBox(height: 32.h),
          AppShimmer.box(width: 200.w, height: 20.h, borderRadius: 8.r),
          SizedBox(height: 8.h),
          AppShimmer.box(width: 160.w, height: 14.h, borderRadius: 6.r),
          SizedBox(height: 40.h),
          _shimmerCard(theme, isDark),
          SizedBox(height: 16.h),
          _shimmerCard(theme, isDark),
          SizedBox(height: 16.h),
          _shimmerSocial(theme, isDark),
        ],
      ),
    );
  }

  Widget _shimmerCard(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Row(children: [
        AppShimmer.box(width: 48.w, height: 48.w, borderRadius: 14.r),
        SizedBox(width: 16.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppShimmer.box(width: 80.w, height: 12.h, borderRadius: 4.r),
          SizedBox(height: 6.h),
          AppShimmer.box(width: 160.w, height: 14.h, borderRadius: 4.r),
        ])),
      ]),
    );
  }

  Widget _shimmerSocial(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          AppShimmer.box(width: 120.w, height: 14.h, borderRadius: 4.r),
          SizedBox(height: 20.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(4, (_) =>
            AppShimmer.box(width: 56.w, height: 56.w, borderRadius: 16.r),
          )),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, ThemeData theme, bool isDark, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 64.sp, color: theme.hintColor),
            SizedBox(height: 16.h),
            Text(LocaleKeys.common.error.tr(context: context),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            Text(LocaleKeys.common.try_again.tr(context: context),
              style: TextStyle(fontSize: 13.sp, color: theme.hintColor)),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(LocaleKeys.common.retry.tr(context: context)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryWine,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, bool isDark, dynamic settings) {
    final mobile = settings.mobile?.toString().trim() ?? '';
    final email = settings.email?.toString().trim() ?? '';
    final facebook = settings.facebook?.toString().trim() ?? '';
    final twitter = settings.twitter?.toString().trim() ?? '';
    final instagram = settings.instagram?.toString().trim() ?? '';
    final telegram = settings.telegram?.toString().trim() ?? '';
    final addressAr = settings.addressAr?.toString().trim() ?? '';
    final addressEn = settings.addressEn?.toString().trim() ?? '';
    final address = context.locale.languageCode == 'ar' ? addressAr : addressEn;

    final hasContact = mobile.isNotEmpty || email.isNotEmpty || address.isNotEmpty;
    final hasSocial = facebook.isNotEmpty || twitter.isNotEmpty || instagram.isNotEmpty || telegram.isNotEmpty;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100.w,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
            ),
            child: settings.logo != null && settings.logo!.isNotEmpty
                ? AppImage(
                    imagePath: settings.logo!,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.store_rounded, size: 44.sp, color: AppColors.primaryWine),
          ),
          SizedBox(height: 24.h),
          Text(LocaleKeys.common.contact_us.tr(context: context),
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Text(LocaleKeys.common.contact_thanks.tr(context: context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: theme.hintColor)),
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                if (hasContact) ...[
                  if (mobile.isNotEmpty)
                    _buildContactCard(
                      theme: theme,
                      isDark: isDark,
                      icon: Icons.phone_rounded,
                      iconColor: Colors.green,
                      label: LocaleKeys.common.phone.tr(context: context),
                      value: mobile,
                      onTap: () => openUrl('tel:$mobile'),
                    ),
                  if (mobile.isNotEmpty && email.isNotEmpty) SizedBox(height: 12.h),
                  if (email.isNotEmpty)
                    _buildContactCard(
                      theme: theme,
                      isDark: isDark,
                      icon: Icons.email_outlined,
                      iconColor: Colors.blue,
                      label: LocaleKeys.common.email.tr(context: context),
                      value: email,
                      onTap: () => openUrl('mailto:$email'),
                    ),
                  if ((mobile.isNotEmpty || email.isNotEmpty) && address.isNotEmpty) SizedBox(height: 12.h),
                  if (address.isNotEmpty)
                    _buildContactCard(
                      theme: theme,
                      isDark: isDark,
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.primaryWine,
                      label: LocaleKeys.webstore.more.contact_address.tr(context: context),
                      value: address,
                      onTap: () => openUrl('https://maps.google.com/?q=${Uri.encodeComponent(address)}'),
                    ),
                  if (hasSocial && hasContact) SizedBox(height: 24.h),
                ],
                if (hasSocial) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.webstore.more.social_media.tr(context: context),
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (facebook.isNotEmpty)
                              _socialButton(theme: theme, icon: Icons.facebook_rounded, color: const Color(0xFF1877F2), label: LocaleKeys.webstore.more.facebook.tr(context: context), onTap: () => openUrl(facebook)),
                            if (twitter.isNotEmpty)
                              _socialButton(theme: theme, icon: Icons.alternate_email_rounded, color: const Color(0xFF1DA1F2), label: LocaleKeys.webstore.more.twitter.tr(context: context), onTap: () => openUrl(twitter)),
                            if (instagram.isNotEmpty)
                              _socialButton(theme: theme, icon: Icons.camera_alt_rounded, color: const Color(0xFFE4405F), label: LocaleKeys.webstore.more.instagram.tr(context: context), onTap: () => openUrl(instagram)),
                            if (telegram.isNotEmpty)
                              _socialButton(theme: theme, icon: Icons.send_rounded, color: const Color(0xFF0088CC), label: LocaleKeys.webstore.more.telegram.tr(context: context), onTap: () => openUrl(telegram)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required ThemeData theme,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontSize: 12.sp, color: theme.hintColor)),
                    SizedBox(height: 2.h),
                    Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: theme.hintColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required ThemeData theme,
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: color, size: 26.sp),
            ),
            SizedBox(height: 6.h),
            Text(label, style: TextStyle(fontSize: 10.sp, color: theme.hintColor)),
          ],
        ),
      ),
    );
  }
}