import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/product_card_widget.dart';
import 'package:erp/core/common_widget/app_image/app_image.dart';
import 'package:erp/core/utils/asset_manager.dart';
import 'package:erp/core/common_widget/app_section_header/app_section_header.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/router/route_generator.dart';

class FlashSaleWidget extends StatefulWidget {
  const FlashSaleWidget({super.key});

  @override
  State<FlashSaleWidget> createState() => _FlashSaleWidgetState();
}

class _FlashSaleWidgetState extends State<FlashSaleWidget> {
  late Timer _timer;
  Duration _duration = const Duration(hours: 4, minutes: 30, seconds: 0);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        AppSectionHeader(
          title: LocaleKeys.webstore.home.tarshooby_offers.tr(context: context),
          onViewAllTap: () {
            AppNavigator.push(
              context,
              AppRouteNames.webstoreCatalogProducts,
              arguments: {'preset': 'latest'},
            );
          },
          child: Row(
            children: [
              AppImage(imagePath: AssetManager.bestSale, height: 24.h),
              12.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDark ? theme.cardColor : Colors.black,
                  borderRadius: BorderRadius.circular(4.r),
                  border: isDark
                      ? Border.all(color: Colors.white.withValues(alpha: 0.1))
                      : null,
                ),
                child: Text(
                  _formatDuration(_duration),
                  style: TextStyle(
                    color: isDark
                        ? theme.textTheme.bodyMedium?.color
                        : Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
        10.verticalSpace,
        Consumer(
          builder: (context, ref, _) {
            final products = ref.watch(
              homeVmProvider.select((s) => s.products),
            );
            if (products.isEmpty) return const SizedBox.shrink();

            // Show only a subset for flash sale
            final flashProducts = products.take(4).toList();

            return SizedBox(
              height: 240.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: flashProducts.length,
                separatorBuilder: (_, __) => 12.horizontalSpace,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 160.w,
                    child: ProductGridCard(product: flashProducts[index]),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
