import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view_model/medical_services_providers.dart';
import 'package:erp/modules/webstore/medical_services/data/models/health_metric_model.dart';
import 'package:erp/modules/webstore/medical_services/data/models/daily_activity_model.dart';

class HealthTwinView extends ConsumerStatefulWidget {
  const HealthTwinView({super.key});

  @override
  ConsumerState<HealthTwinView> createState() => _HealthTwinViewState();
}

class _HealthTwinViewState extends ConsumerState<HealthTwinView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return WebStoreBaseScaffold(
      title: Text(
        'التوأم الصحي',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      showBack: true,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            _buildPatientHeader(isDark),
            20.verticalSpace,
            _buildDailyActivitiesSection(isDark),
            20.verticalSpace,
            _buildHealthMetricsSection(isDark),
            20.verticalSpace,
            _buildQuickActionsSection(isDark),
            80.verticalSpace,
          ],
        ),
      ),
    );
  }

  // ─── Patient Header ──────────────────────────────────────────
  Widget _buildPatientHeader(bool isDark) {
    final profileAsync = ref.watch(healthProfileProvider);
    final activitiesAsync = ref.watch(dailyActivitiesProvider);

    final healthScore = activitiesAsync.when(
      data: (activities) {
        if (activities.isEmpty) return 0.0;
        double total = 0;
        activities.forEach((_, a) => total += a.progress);
        return (total / activities.length * 100).roundToDouble();
      },
      loading: () => 0.0,
      error: (_, _) => 0.0,
    );

    return AppAnimation.fadeInDown(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
                : [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: profileAsync.when(
          data: (profile) {
            if (profile == null) return _buildDefaultHeader(isDark);
            return Row(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      profile.gender == 'male' ? '🧑' : '👩',
                      style: TextStyle(fontSize: 32.sp),
                    ),
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحباً بك',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12.sp,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        '${profile.age} سنة • ${profile.bloodType ?? ''}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          Text(
                            '${profile.weight?.toStringAsFixed(1) ?? '--'} كجم',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            '${profile.height?.toInt() ?? '--'} سم',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 64.w,
                  height: 64.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 64.w,
                        height: 64.w,
                        child: CircularProgressIndicator(
                          value: healthScore / 100,
                          strokeWidth: 5,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          color: Colors.white,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${healthScore.toInt()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          Text(
                            '%',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 10.sp,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => _buildDefaultHeader(isDark),
          error: (_, _) => _buildDefaultHeader(isDark),
        ),
      ),
    );
  }

  Widget _buildDefaultHeader(bool isDark) {
    return Row(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(Icons.person, color: Colors.white, size: 32.sp),
          ),
        ),
        14.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ملفك الصحي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              4.verticalSpace,
              Text(
                'تابع يومي لحالتك الصحية',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Daily Activities Section ────────────────────────────────
  Widget _buildDailyActivitiesSection(bool isDark) {
    final activitiesAsync = ref.watch(dailyActivitiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Icon(Icons.today_rounded, size: 20.sp, color: AppColors.primary),
              8.horizontalSpace,
              Text(
                'نشاط اليوم',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
        12.verticalSpace,
        activitiesAsync.when(
          data: (activities) {
            if (activities.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildActivityCard(
                          activities['steps'],
                          isDark,
                          () => _showAddValueDialog(context, 'steps', 'المشي', 'خطوة'),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: _buildActivityCard(
                          activities['water'],
                          isDark,
                          () => _showAddValueDialog(context, 'water', 'المية', 'كوباية'),
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: _buildActivityCard(
                          activities['sleep'],
                          isDark,
                          () => _showAddValueDialog(context, 'sleep', 'النوم', 'ساعة'),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: _buildActivityCard(
                          activities['calories'],
                          isDark,
                          () => _showAddValueDialog(context, 'calories', 'السعرات', 'سعرة'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => SizedBox(
            height: 200.h,
            child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          ),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildActivityCard(DailyActivity? activity, bool isDark, VoidCallback onAdd) {
    if (activity == null) return const SizedBox.shrink();
    final color = Color(activity.colorValue);

    return AppAnimation.fadeZoomIn(
      child: GestureDetector(
        onTap: onAdd,
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: color.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(activity.icon, style: TextStyle(fontSize: 20.sp)),
                  const Spacer(),
                  GestureDetector(
                    onTap: onAdd,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: color, size: 16.sp),
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Text(
                activity.label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              4.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatValue(activity.currentValue),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textColor,
                      height: 1,
                    ),
                  ),
                  4.horizontalSpace,
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Text(
                      activity.unit,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: LinearProgressIndicator(
                  value: activity.progress,
                  minHeight: 6.h,
                  backgroundColor: color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              4.verticalSpace,
              Text(
                '${_formatValue(activity.currentValue)} / ${_formatValue(activity.targetValue)} ${activity.unit}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }

  // ─── Health Metrics Section ──────────────────────────────────
  Widget _buildHealthMetricsSection(bool isDark) {
    final metricsAsync = ref.watch(healthMetricsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Icon(Icons.monitor_heart_rounded, size: 20.sp, color: AppColors.primary),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  'المقياسات الصحية',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showAddMetricSheet(context, isDark),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: AppColors.primary, size: 14.sp),
                      4.horizontalSpace,
                      Text(
                        'إضافة',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        12.verticalSpace,
        metricsAsync.when(
          data: (metrics) {
            if (metrics.isEmpty) {
              return _buildNoMetrics(isDark);
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: metrics.asMap().entries.map((entry) {
                  return AppAnimation.fadeInUp(
                    delay: Duration(milliseconds: entry.key * 80),
                    child: _buildMetricTile(entry.value, isDark),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => Padding(
            padding: EdgeInsets.all(24.w),
            child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          ),
          error: (_, _) => _buildNoMetrics(isDark),
        ),
      ],
    );
  }

  Widget _buildMetricTile(HealthMetricModel metric, bool isDark) {
    final statusColor = switch (metric.healthStatus) {
      HealthStatus.normal => AppColors.success,
      HealthStatus.warning => AppColors.warning,
      HealthStatus.critical => AppColors.error,
    };
    final statusLabel = switch (metric.healthStatus) {
      HealthStatus.normal => 'طبيعي',
      HealthStatus.warning => 'تنبيه',
      HealthStatus.critical => 'حرج',
    };

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              _metricIcon(metric.type),
              color: statusColor,
              size: 22.sp,
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
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
                2.verticalSpace,
                Text(
                  _timeAgo(metric.recordedAt),
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${metric.value.toStringAsFixed(metric.value == metric.value.roundToDouble() ? 0 : 1)} ${metric.unit}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
              2.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _metricIcon(String type) {
    return switch (type) {
      'blood_pressure' => Icons.favorite_rounded,
      'blood_sugar' => Icons.water_drop_rounded,
      'heart_rate' => Icons.monitor_heart_rounded,
      'temperature' => Icons.thermostat_rounded,
      'spo2' => Icons.air_rounded,
      _ => Icons.medical_information_rounded,
    };
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعات';
    return 'منذ ${diff.inDays} أيام';
  }

  Widget _buildNoMetrics(bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.medical_information_outlined, size: 40.sp, color: AppColors.textHint),
            8.verticalSpace,
            Text(
              'لا توجد مقياسات بعد',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            4.verticalSpace,
            Text(
              'اضغط "إضافة" لتسجيل قياس صحي',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Quick Actions ──────────────────────────────────────────
  Widget _buildQuickActionsSection(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إجراءات سريعة',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textColor,
            ),
          ),
          12.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.favorite_rounded,
                  label: 'ضغط الدم',
                  color: AppColors.error,
                  isDark: isDark,
                  onTap: () => _showAddMetricSheet(context, isDark, initialType: 'blood_pressure'),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: _buildQuickAction(
                  icon: Icons.water_drop_rounded,
                  label: 'سكر الدم',
                  color: AppColors.info,
                  isDark: isDark,
                  onTap: () => _showAddMetricSheet(context, isDark, initialType: 'blood_sugar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18.sp),
            8.horizontalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Add Value Dialog ───────────────────────────────────────
  void _showAddValueDialog(BuildContext context, String type, String label, String unit) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Text('إضافة $label', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
          decoration: InputDecoration(
            hintText: 'أدخل العدد بالـ $unit',
            suffixText: unit,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                ref.read(dailyActivitiesProvider.notifier).addValue(type, value);
                Navigator.pop(ctx);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  // ─── Add Metric Bottom Sheet ────────────────────────────────
  void _showAddMetricSheet(BuildContext context, bool isDark, {String? initialType}) {
    final types = [
      ('blood_pressure', 'ضغط الدم', '/80 mmHg'),
      ('blood_sugar', 'سكر الدم', 'mg/dL'),
      ('heart_rate', 'نبضات القلب', 'ب/د'),
      ('temperature', 'درجة الحرارة', '°C'),
      ('spo2', 'ت_saturation الأكسجين', '%'),
    ];

    String selectedType = initialType ?? types[0].$1;
    final valueController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final selected = types.firstWhere((t) => t.$1 == selectedType);

          return Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                16.verticalSpace,
                Text(
                  'إضافة قياس صحي',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
                16.verticalSpace,
                Text(
                  'نوع القياس',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                8.verticalSpace,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: types.map((t) {
                    final isSelected = t.$1 == selectedType;
                    return GestureDetector(
                      onTap: () => setSheetState(() => selectedType = t.$1),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          t.$2,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                16.verticalSpace,
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
                  decoration: InputDecoration(
                    hintText: 'القيمة (${selected.$3})',
                    suffixText: selected.$3,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                20.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: FilledButton(
                    onPressed: () async {
                      final value = double.tryParse(valueController.text);
                      if (value == null || value <= 0) return;

                      await ref.read(healthMetricsProvider.notifier).addMetric({
                        'type': selectedType,
                        'label': selected.$2,
                        'value': value,
                        'unit': selected.$3,
                        'status': 'normal',
                      });

                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      'حفظ القياس',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                8.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}
