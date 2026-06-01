import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';

class WebStoreRateOrderStarRatingWidget extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingUpdate;
  final double size;

  const WebStoreRateOrderStarRatingWidget({
    super.key,
    required this.rating,
    required this.onRatingUpdate,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      child: Column(
        children: [
          Row(
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
          ),
          12.verticalSpace,
          Text(
            rating >= 4
                ? LocaleKeys.webstore.orders.excellent_service.tr(context: context)
                : (rating == 0
                    ? LocaleKeys.webstore.orders.tap_to_rate.tr(context: context)
                    : LocaleKeys.webstore.orders.could_be_better.tr(context: context)),
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.primaryOrange),
          ),
        ],
      ),
    );
  }
}
