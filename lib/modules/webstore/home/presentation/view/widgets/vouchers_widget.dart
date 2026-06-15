import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';

class VouchersWidget extends ConsumerWidget {
  const VouchersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeVmProvider);
    final coupons = homeState.coupons;

    if (coupons.isEmpty) return const SizedBox.shrink();

    return AppAnimation.fadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: LocaleKeys.webstore.home.vouchers_title.tr(context: context),

          ),
          SizedBox(
            height: 110.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: coupons.length,
              separatorBuilder: (_, __) => 12.horizontalSpace,
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                final theme = Theme.of(context);
                final isDark = theme.brightness == Brightness.dark;

                final lightColors = [
                  const Color(0xFFE3F2FD), // Light Blue
                  const Color(0xFFF1F8E9), // Light Green
                  const Color(0xFFF3E5F5), // Light Purple
                  const Color(0xFFFFF3E0), // Light Orange
                ];
                final darkColors = [
                  const Color(0xFF1A237E).withValues(alpha: 0.3),
                  const Color(0xFF1B5E20).withValues(alpha: 0.3),
                  const Color(0xFF4A148C).withValues(alpha: 0.3),
                  const Color(0xFFE65100).withValues(alpha: 0.3),
                ];

                final textColors = [
                  isDark ? const Color(0xFF90CAF9) : const Color(0xFF1976D2),
                  isDark ? const Color(0xFFA5D6A7) : const Color(0xFF388E3C),
                  isDark ? const Color(0xFFCE93D8) : const Color(0xFF7B1FA2),
                  isDark ? const Color(0xFFFFCC80) : const Color(0xFFF57C00),
                ];

                return _buildVoucherCard(
                  coupon.valueLabel,
                  coupon.description,
                  isDark
                      ? darkColors[index % darkColors.length]
                      : lightColors[index % lightColors.length],
                  textColors[index % textColors.length],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(String discount, String description, Color bgColor,
      Color textColor) {
    return AppCard(
      width: 200.w,
      backgroundColor: bgColor,
      borderRadius: 20.r,
      padding: EdgeInsets.zero,
      onTap: () {},
      child: Stack(
        children: [
          // Background circles for premium design
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        discount,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor.withValues(alpha: 0.8),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.card_giftcard_rounded,
                    color: textColor.withValues(alpha: 0.3), size: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
