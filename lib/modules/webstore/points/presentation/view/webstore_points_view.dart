import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_card/app_card.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/points/presentation/view_model/points_providers.dart';

class WebStorePointsView extends ConsumerStatefulWidget {
  const WebStorePointsView({super.key});

  @override
  ConsumerState<WebStorePointsView> createState() => _WebStorePointsViewState();
}

class _WebStorePointsViewState extends ConsumerState<WebStorePointsView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pointsAsync = ref.watch(pointsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(titleText: 'webstore.points.title'.tr(context: context)),
      body: RefreshIndicator(
        onRefresh: () => ref.read(pointsProvider.notifier).refresh(),
        child: pointsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator.adaptive()),
          error: (err, stack) => SingleChildScrollView(
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
                      'حدث خطأ ما: $err',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.sp, color: theme.hintColor),
                    ),
                    16.verticalSpace,
                    ElevatedButton(
                      onPressed: () => ref.read(pointsProvider.notifier).refresh(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data: (pointsModel) {
            final transactions = pointsModel.transactions;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppAnimation.fadeInDown(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOrange.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'webstore.points.balance'.tr(context: context),
                            style: TextStyle(fontSize: 16.sp, color: Colors.white.withValues(alpha: 0.8)),
                          ),
                          8.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                pointsModel.balance.toString(),
                                style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w900, color: Colors.white, height: 1),
                              ),
                              8.horizontalSpace,
                              Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: Text(
                                  'webstore.points.point'.tr(context: context),
                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          if (pointsModel.monetaryValue != null) ...[
                            8.verticalSpace,
                            Text(
                              '≈ \$${pointsModel.monetaryValue!.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.7)),
                            ),
                          ],
                          if (pointsModel.nearestExpiryDate != null) ...[
                            8.verticalSpace,
                            Text(
                              'ينتهي في: ${pointsModel.nearestExpiryDate}',
                              style: TextStyle(fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.6)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  24.verticalSpace,

                  Row(
                    children: [
                      _statCard(theme, 'webstore.points.earned'.tr(), pointsModel.totalEarned.toString(), Colors.green),
                      12.horizontalSpace,
                      _statCard(theme, 'webstore.points.spent'.tr(), pointsModel.totalUsed.toString(), Colors.red),
                      12.horizontalSpace,
                      if (pointsModel.totalExpired > 0)
                        _statCard(theme, 'منتهية', pointsModel.totalExpired.toString(), Colors.grey),
                    ],
                  ),

                  24.verticalSpace,

                  Text(
                    'webstore.points.history'.tr(context: context),
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
                  ),
                  16.verticalSpace,

                  if (transactions.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Text(
                          'لا يوجد سجل نقاط حالياً',
                          style: TextStyle(color: theme.hintColor, fontSize: 14.sp),
                        ),
                      ),
                    )
                  else
                    ...transactions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final t = entry.value;
                      final isEarned = t.isEarned;

                      return AppAnimation.fadeInUp(
                        delay: Duration(milliseconds: index * 50),
                        child: Column(
                          children: [
                            AppCard(
                              padding: EdgeInsets.all(16.w),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: (isEarned ? Colors.green : Colors.red).withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isEarned ? Icons.add_rounded : Icons.remove_rounded,
                                      color: isEarned ? Colors.green : Colors.red,
                                      size: 24.sp,
                                    ),
                                  ),
                                  16.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          t.title,
                                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                        ),
                                        4.verticalSpace,
                                        Text(
                                          t.date,
                                          style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                                        ),
                                        if (t.expiryDate != null) ...[
                                          2.verticalSpace,
                                          Text(
                                            'تنتهي: ${t.expiryDate}',
                                            style: TextStyle(fontSize: 10.sp, color: Colors.orange),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${isEarned ? '+' : '-'}${t.points}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w900,
                                      color: isEarned ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            12.verticalSpace,
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statCard(ThemeData theme, String label, String value, Color color) {
    return Expanded(
      child: AppCard(
        padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 12.w),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: color),
            ),
            4.verticalSpace,
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
