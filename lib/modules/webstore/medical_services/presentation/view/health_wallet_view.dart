import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view_model/medical_services_providers.dart';
import 'package:erp/modules/webstore/medical_services/data/models/health_metric_model.dart';

class HealthWalletView extends ConsumerWidget {
  const HealthWalletView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final profileAsync = ref.watch(healthProfileProvider);
    final metricsAsync = ref.watch(healthMetricsProvider);

    return WebStoreBaseScaffold(
      title: Text(
        'المحفظة الصحية',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      showBack: true,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.verticalSpace,

            // Profile Card
            profileAsync.when(
              data: (profile) => profile != null
                  ? _buildProfileCard(profile, isDark, context)
                  : _buildEmptyProfile(isDark, context),
              loading: () => _buildShimmerCard(isDark),
              error: (_, __) => _buildEmptyProfile(isDark, context),
            ),
            20.verticalSpace,

            // QR Share Button
            _buildQRShareCard(isDark, context),
            20.verticalSpace,

            // BMI Card
            profileAsync.when(
              data: (profile) => profile?.bmi != null
                  ? _buildBMICard(profile!, isDark)
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Health Metrics
            Text(
              'المؤشرات الصحية',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            12.verticalSpace,

            metricsAsync.when(
              data: (metrics) => metrics.isNotEmpty
                  ? Column(
                      children: metrics.asMap().entries.map((entry) {
                        return AppAnimation.fadeInUp(
                          delay: Duration(milliseconds: entry.key * 100),
                          child: _buildMetricTile(entry.value, isDark),
                        );
                      }).toList(),
                    )
                  : _buildEmptyMetrics(isDark),
              loading: () => Column(
                children: List.generate(3, (i) => _buildShimmerMetric(isDark)),
              ),
              error: (_, __) => _buildEmptyMetrics(isDark),
            ),
            20.verticalSpace,

            // Allergies & Conditions
            profileAsync.when(
              data: (profile) => profile != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (profile.allergies.isNotEmpty) ...[
                          Text(
                            'الحساسيات',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textColor,
                            ),
                          ),
                          12.verticalSpace,
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: profile.allergies.map((allergy) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: AppColors.error.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: AppColors.error,
                                      size: 16.sp,
                                    ),
                                    6.horizontalSpace,
                                    Text(
                                      allergy,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          20.verticalSpace,
                        ],
                        if (profile.chronicDiseases.isNotEmpty) ...[
                          Text(
                            'الأمراض المزمنة',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textColor,
                            ),
                          ),
                          12.verticalSpace,
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: profile.chronicDiseases.map((disease) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: AppColors.warning.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.medical_services,
                                      color: AppColors.warning,
                                      size: 16.sp,
                                    ),
                                    6.horizontalSpace,
                                    Text(
                                      disease,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AppColors.warning,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    )
                  : const SizedBox.shrink(),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            80.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(HealthProfileModel profile, bool isDark, BuildContext context) {
    return AppAnimation.fadeInUp(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1A237E), const Color(0xFF0D47A1)]
                : [const Color(0xFF465CA7), const Color(0xFF1A73E8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF465CA7).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Icon(
                    profile.gender == 'male' ? Icons.male : Icons.female,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الملف الشخصي الصحي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        '${profile.age ?? '—'} سنة • ${profile.bloodType ?? '—'}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 20.sp,
                ),
              ],
            ),
            if (profile.weight != null && profile.height != null) ...[
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProfileStat('الوزن', '${profile.weight} كجم', Icons.monitor_weight),
                  _buildProfileStat('الطول', '${profile.height} سم', Icons.height),
                  _buildProfileStat('BMI', profile.bmi!.toStringAsFixed(1), Icons.speed),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20.sp),
        4.verticalSpace,
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyProfile(bool isDark, BuildContext context) {
    return AppAnimation.fadeInUp(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.person_add_rounded,
              color: const Color(0xFF6C63FF),
              size: 40.sp,
            ),
            12.verticalSpace,
            Text(
              'أكمل ملفك الصحي',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            4.verticalSpace,
            Text(
              'أضف بياناتك الصحية للحصول على تحليل أفضل',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'أضف بياناتك',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRShareCard(bool isDark, BuildContext context) {
    return AppAnimation.fadeInUp(
      delay: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTap: () {
          // TODO: Generate and show QR code
        },
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.qr_code_2_rounded,
                  color: const Color(0xFF6C63FF),
                  size: 24.sp,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مشاركة بالـ QR Code',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textColor,
                      ),
                    ),
                    Text(
                      'اعرض بياناتك الصحية لأي دكتور',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textHint,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBMICard(HealthProfileModel profile, bool isDark) {
    final bmi = profile.bmi!;
    final bmiStatus = bmi < 18.5
        ? 'نقص الوزن'
        : bmi < 25
            ? 'وزن طبيعي'
            : bmi < 30
                ? 'وزن زائد'
                : 'سمنة';
    final bmiColor = bmi < 18.5
        ? AppColors.info
        : bmi < 25
            ? AppColors.success
            : bmi < 30
                ? AppColors.warning
                : AppColors.error;

    return AppAnimation.fadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: bmiColor, size: 22.sp),
                8.horizontalSpace,
                Text(
                  'مؤشر كتلة الجسم',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: bmiColor,
                        ),
                      ),
                      Text(
                        bmiStatus,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: bmiColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: (bmi / 40).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.shade200,
                      color: bmiColor,
                      minHeight: 8.h,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(HealthMetricModel metric, bool isDark) {
    final statusColor = metric.healthStatus == HealthStatus.normal
        ? AppColors.success
        : metric.healthStatus == HealthStatus.warning
            ? AppColors.warning
            : AppColors.error;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
                Text(
                  _formatDate(metric.recordedAt),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${metric.value.toStringAsFixed(1)} ${metric.unit}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMetrics(bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.monitor_heart_outlined,
              color: AppColors.textHint,
              size: 40.sp,
            ),
            12.verticalSpace,
            Text(
              'لا توجد مؤشرات بعد',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard(bool isDark) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }

  Widget _buildShimmerMetric(bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      height: 60.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
