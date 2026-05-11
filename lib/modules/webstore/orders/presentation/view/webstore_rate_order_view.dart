import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/constants/app_constants.dart';

class WebStoreRateOrderView extends StatefulWidget {
  const WebStoreRateOrderView({super.key});

  @override
  State<WebStoreRateOrderView> createState() => _WebStoreRateOrderViewState();
}

class _WebStoreRateOrderViewState extends State<WebStoreRateOrderView> {
  double deliveryRating = 0.0;
  Map<int, double> productRatings = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CommonAppBar(titleText: 'Rate Order'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ──────────────────────────────────
            AppAnimation.fadeInDown(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star_rounded, color: AppColors.primaryOrange, size: 48.sp),
                    ),
                    20.verticalSpace,
                    Text(
                      'How was your experience?',
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    8.verticalSpace,
                    Text(
                      'Your feedback helps us improve our service.',
                      style: TextStyle(fontSize: 14.sp, color: theme.hintColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            32.verticalSpace,

            // ─── Delivery Rating ─────────────────────────
            _sectionHeader('Rate Delivery Service'),
            12.verticalSpace,
            AppCard(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              child: Column(
                children: [
                  _starRatingRow(
                    rating: deliveryRating,
                    onRatingUpdate: (val) => setState(() => deliveryRating = val),
                  ),
                  12.verticalSpace,
                   Text(
                    deliveryRating >= 4 ? 'Excellent Service!' : (deliveryRating == 0 ? 'Tap to rate' : 'Could be better'),
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.primaryOrange),
                  ),
                ],
              ),
            ),
            
            32.verticalSpace,

            // ─── Feedback Field ──────────────────────────
            _sectionHeader('Add Feedback (Optional)'),
            12.verticalSpace,
            AppCard(
               padding: EdgeInsets.all(16.w),
               child: TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts about your order...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14.sp, color: theme.hintColor),
                  ),
               ),
            ),
            
            40.verticalSpace,

            // Submit Button
            AppButton(
              onPressed: () => AppNavigator.pushAndRemoveUntil(context, AppRouteNames.webstoreMain),
              isGradient: true,
              child: Text(
                'Submit Feedback',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
    );
  }

  Widget _starRatingRow({required double rating, required ValueChanged<double> onRatingUpdate, double size = 32.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final currentRating = index + 1.0;
        final bool isSelected = rating >= currentRating;
        return IconButton(
          onPressed: () => onRatingUpdate(currentRating),
          icon: Icon(
            isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
            color: isSelected ? Colors.amber : Colors.grey[400],
            size: size,
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          constraints: const BoxConstraints(),
        );
      }),
    );
  }
}
