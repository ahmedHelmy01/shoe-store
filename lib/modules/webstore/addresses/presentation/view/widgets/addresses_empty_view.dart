import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressesEmptyView extends StatelessWidget {
  const AddressesEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 0.7.sh,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_rounded,
                size: 80.sp,
                color: theme.hintColor.withValues(alpha: 0.3),
              ),
              16.verticalSpace,
              Text(
                'لا يوجد عناوين توصيل مضافة',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                ),
              ),
              8.verticalSpace,
              Text(
                'أضف عنوان توصيل ليسهل عليك إنهاء طلباتك بسرعة',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.hintColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
