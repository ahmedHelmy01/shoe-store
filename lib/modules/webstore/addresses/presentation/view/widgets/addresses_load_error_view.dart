import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressesLoadErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const AddressesLoadErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(20.w),
      child: SizedBox(
        height: 0.6.sh,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 60.sp, color: Colors.red),
              16.verticalSpace,
              Text(
                'حدث خطأ ما: $error',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: theme.hintColor),
              ),
              16.verticalSpace,
              ElevatedButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
            ],
          ),
        ),
      ),
    );
  }
}
