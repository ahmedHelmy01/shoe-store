import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/utils/asset_manager.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onFacebookTap;
  final VoidCallback onAppleTap;

  const SocialLoginSection({
    super.key,
    required this.onGoogleTap,
    required this.onFacebookTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.3))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'أو',
                style: TextStyle(
                  color: theme.hintColor.withOpacity(0.6),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(child: Divider(color: theme.dividerColor.withOpacity(0.3))),
          ],
        ),
        24.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              assetPath: AssetManager.google,
              onTap: onGoogleTap,
              isDark: isDark,
            ),
            16.horizontalSpace,
            _SocialButton(
              assetPath: AssetManager.facebook,
              onTap: onFacebookTap,
              isDark: isDark,
            ),
            if (Theme.of(context).platform == TargetPlatform.iOS) ...[
              16.horizontalSpace,
              _SocialButton(
                assetPath: AssetManager.apple,
                onTap: onAppleTap,
                isDark: isDark,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final bool isDark;

  const _SocialButton({
    required this.assetPath,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60.w,
        height: 60.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade100,
            width: 1.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: AppImage(
          imagePath: assetPath,
        ),
      ),
    );
  }
}
