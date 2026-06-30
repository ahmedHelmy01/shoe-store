import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/network_check_internet.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';

class NetworkListener extends ConsumerWidget {
  final Widget child;
  const NetworkListener({super.key, required this.child});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(networkStatusProvider);
    final isDisconnected = !isConnected;
    return Stack(
      alignment: AlignmentDirectional.topStart, // Explicitly directional
      children: [
        child,
        // Animated banner — slides down when disconnected, slides up when reconnected
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          reverseDuration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1), // Start above the screen
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: isDisconnected
              ? _NoInternetBanner(key: const ValueKey('no_internet_banner'))
              : const SizedBox.shrink(key: ValueKey('connected')),
        ),
      ],
    );
  }
}

/// Extracted banner widget for cleaner code and proper AnimatedSwitcher keying.
class _NoInternetBanner extends StatelessWidget {
  const _NoInternetBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.boldOrange.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.wifi_off_rounded, color: Colors.white),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.common.no_internet.tr(context: context),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        LocaleKeys.common.check_internet.tr(context: context),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
