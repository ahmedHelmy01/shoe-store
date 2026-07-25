import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';

class AppPriceText extends StatelessWidget {
  final double price;
  final double? oldPrice;
  final String currency;
  final TextStyle? priceStyle;
  final TextStyle? oldPriceStyle;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const AppPriceText({
    super.key,
    required this.price,
    this.oldPrice,
    this.currency = AppConstants.currency,
    this.priceStyle,
    this.oldPriceStyle,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = oldPrice != null && oldPrice! > price;

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (hasDiscount)
          Text(
            '$oldPrice $currency',
            style: oldPriceStyle ?? TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[400],
              decoration: TextDecoration.lineThrough,
            ),
          ),
        Text(
          '$price $currency',
          style: priceStyle ?? TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryOrange,
          ),
        ),
      ],
    );
  }
}
