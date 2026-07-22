import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view_model/medical_services_providers.dart';
import 'package:erp/modules/webstore/medical_services/data/models/daily_activity_model.dart';

class HealthGamificationView extends ConsumerWidget {
  const HealthGamificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gamificationAsync = ref.watch(gamificationProvider);
    final activitiesAsync = ref.watch(dailyActivitiesProvider);
    final computedAchievements = ref.watch(computedAchievementsProvider);

    return WebStoreBaseScaffold(
      title: Text(
        'تحدي الصحة',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      showBack: true,
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Activity Overview (from Health Twin)
            _buildTodayActivitySection(activitiesAsync, isDark),
            24.verticalSpace,

            gamificationAsync.when(
              data: (data) {
                if (data == null) return _buildEmptyState(isDark);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Level & Points Header
                    _buildLevelHeader(data, isDark),
                    24.verticalSpace,

                    // Streak Card
                    _buildStreakCard(data.streak, isDark),
                    24.verticalSpace,

                    // Achievements (auto-calculated from real data)
                    _buildAchievementsSection(computedAchievements, isDark),
                    24.verticalSpace,

                    // Daily Challenges (linked to real activity data)
                    Text(
                      'تحديات اليوم',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textColor,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'التقدم بيتحسب من بياناتك في التوأم الصحي',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    12.verticalSpace,

                    // Build dynamic challenges from activity data
                    ..._buildDynamicChallenges(activitiesAsync, isDark),

                    // Static challenges from server
                    ...data.challenges.asMap().entries.map((entry) {
                      return AppAnimation.fadeInUp(
                        delay: Duration(milliseconds: (entry.key + 4) * 100),
                        child: _buildStaticChallengeCard(entry.value, isDark),
                      );
                    }),
                    80.verticalSpace,
                  ],
                );
              },
              loading: () => Center(
                child: Padding(
                  padding: EdgeInsets.all(40.w),
                  child: CircularProgressIndicator(color: AppColors.primaryOrange),
                ),
              ),
              error: (_, _) => _buildEmptyState(isDark),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Today's Activity Section ────────────────────────────────
  Widget _buildTodayActivitySection(
      AsyncValue<Map<String, DailyActivity>> activitiesAsync, bool isDark) {
    return AppAnimation.fadeInDown(
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6C63FF),
              const Color(0xFF3F3D99),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: activitiesAsync.when(
          data: (activities) {
            if (activities.isEmpty) {
              return Row(
                children: [
                  Icon(Icons.hourglass_empty_rounded,
                      color: Colors.white, size: 32.sp),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      'ابدأ تسجيل نشاطك اليومي في التوأم الصحي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.today_rounded, color: Colors.white, size: 22.sp),
                    8.horizontalSpace,
                    Text(
                      'نشاط اليوم',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        _calculateOverallProgress(activities),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                ...activities.entries.map((entry) {
                  final activity = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(activity.icon, style: TextStyle(fontSize: 16.sp)),
                            6.horizontalSpace,
                            Text(
                              activity.label,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12.sp,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${_formatValue(activity.currentValue)} / ${_formatValue(activity.targetValue)} ${activity.unit}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        6.verticalSpace,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: activity.progress,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            color: Colors.white,
                            minHeight: 5.h,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: Colors.white.withValues(alpha: 0.7),
              strokeWidth: 2,
            ),
          ),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  String _calculateOverallProgress(Map<String, DailyActivity> activities) {
    if (activities.isEmpty) return '0%';
    double total = 0;
    activities.forEach((_, a) => total += a.progress);
    return '${(total / activities.length * 100).toInt()}%';
  }

  // ─── Dynamic Challenges (from activity data) ─────────────────
  List<Widget> _buildDynamicChallenges(
      AsyncValue<Map<String, DailyActivity>> activitiesAsync, bool isDark) {
    return activitiesAsync.when(
      data: (activities) {
        if (activities.isEmpty) return [];

        final challengeData = <Map<String, dynamic>>[];

        activities.forEach((key, activity) {
          switch (key) {
            case 'steps':
              challengeData.add({
                'title': 'تحدي المشي',
                'description':
                    'امشي ${_formatValue(activity.targetValue)} خطوة اليوم',
                'icon': Icons.directions_walk_rounded,
                'color': const Color(0xFF4CAF50),
                'current': activity.currentValue,
                'target': activity.targetValue,
                'unit': activity.unit,
                'reward': 150,
              });
              break;
            case 'water':
              challengeData.add({
                'title': 'تحدي المية',
                'description':
                    'اشرب ${_formatValue(activity.targetValue)} كوبايات مية',
                'icon': Icons.water_drop_rounded,
                'color': const Color(0xFF2196F3),
                'current': activity.currentValue,
                'target': activity.targetValue,
                'unit': activity.unit,
                'reward': 100,
              });
              break;
            case 'sleep':
              challengeData.add({
                'title': 'تحدي النوم',
                'description': 'نام ${_formatValue(activity.targetValue)} ساعات',
                'icon': Icons.bedtime_rounded,
                'color': const Color(0xFF9C27B0),
                'current': activity.currentValue,
                'target': activity.targetValue,
                'unit': activity.unit,
                'reward': 120,
              });
              break;
            case 'calories':
              challengeData.add({
                'title': 'تحدي السعرات',
                'description':
                    'احرق ${_formatValue(activity.targetValue)} سعرة',
                'icon': Icons.local_fire_department_rounded,
                'color': const Color(0xFFFF9800),
                'current': activity.currentValue,
                'target': activity.targetValue,
                'unit': activity.unit,
                'reward': 130,
              });
              break;
          }
        });

        return challengeData.asMap().entries.map((entry) {
          final challenge = entry.value;
          final progress = (challenge['current'] as double) /
              (challenge['target'] as double);
          final clampedProgress = progress.clamp(0.0, 1.0);
          final isCompleted = clampedProgress >= 1.0;

          return AppAnimation.fadeInUp(
            delay: Duration(milliseconds: entry.key * 100),
            child: _buildDynamicChallengeCard(
              title: challenge['title'] as String,
              description: challenge['description'] as String,
              icon: challenge['icon'] as IconData,
              color: challenge['color'] as Color,
              progress: clampedProgress,
              current: challenge['current'] as double,
              target: challenge['target'] as double,
              unit: challenge['unit'] as String,
              reward: challenge['reward'] as int,
              isCompleted: isCompleted,
              isDark: isDark,
            ),
          );
        }).toList();
      },
      loading: () => [],
      error: (_, _) => [],
    );
  }

  Widget _buildDynamicChallengeCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required double progress,
    required double current,
    required double target,
    required String unit,
    required int reward,
    required bool isCompleted,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isCompleted
            ? Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textColor,
                          ),
                        ),
                        if (isCompleted) ...[
                          6.horizontalSpace,
                          Icon(Icons.check_circle,
                              color: AppColors.success, size: 16.sp),
                        ],
                      ],
                    ),
                    2.verticalSpace,
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars, color: const Color(0xFFFFA000), size: 12.sp),
                    3.horizontalSpace,
                    Text(
                      '+$reward',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB8860B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withValues(alpha: 0.1),
                    color: isCompleted ? AppColors.success : color,
                    minHeight: 6.h,
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                '${_formatValue(current)} / ${_formatValue(target)}',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? AppColors.success : color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Level Header ───────────────────────────────────────────
  Widget _buildLevelHeader(GamificationData data, bool isDark) {
    final levelProgress = (data.totalPoints % 1000) / 1000;

    return AppAnimation.fadeInUp(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFD700),
              const Color(0xFFFFA000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
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
                        data.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'المستوى ${data.level}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.stars_rounded, color: Colors.white, size: 28.sp),
                    Text(
                      '${data.totalPoints}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'نقطة',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            16.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'التقدم للمستوى التالي',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      '${(levelProgress * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                6.verticalSpace,
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: levelProgress,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    color: Colors.white,
                    minHeight: 8.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Streak Card ────────────────────────────────────────────
  Widget _buildStreakCard(int streak, bool isDark) {
    return AppAnimation.fadeInUp(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primaryOrange.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: AppColors.primaryOrange,
                size: 26.sp,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سلسلة العادات الصحية',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textColor,
                    ),
                  ),
                  Text(
                    'استمر! كل يوم تزود نقاطك',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$streak يوم',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Achievement Badge ──────────────────────────────────────
  // ─── Achievements Section (auto-calculated) ────────────────
  Widget _buildAchievementsSection(List<ComputedAchievement> achievements, bool isDark) {
    final unlocked = achievements.where((a) => a.isUnlocked).length;
    final total = achievements.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'الإنجازات',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '$unlocked / $total',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
        12.verticalSpace,
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            separatorBuilder: (_, _) => 10.horizontalSpace,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return AppAnimation.fadeInUp(
                delay: Duration(milliseconds: index * 80),
                child: _buildComputedAchievementBadge(achievement, isDark),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildComputedAchievementBadge(ComputedAchievement achievement, bool isDark) {
    return Tooltip(
      message: achievement.description,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: achievement.isUnlocked
              ? const Color(0xFFFFD700).withValues(alpha: 0.1)
              : isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: achievement.isUnlocked
                ? const Color(0xFFFFD700).withValues(alpha: 0.3)
                : isDark
                    ? Colors.white12
                    : Colors.grey.shade200,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              achievement.icon,
              style: TextStyle(
                fontSize: 32.sp,
                color: achievement.isUnlocked ? null : Colors.grey,
              ),
            ),
            8.verticalSpace,
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: achievement.isUnlocked
                    ? const Color(0xFFB8860B)
                    : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Static Challenge Card (from server) ────────────────────
  Widget _buildStaticChallengeCard(HealthChallenge challenge, bool isDark) {
    final progressColor = challenge.progress > 0.7
        ? AppColors.success
        : challenge.progress > 0.3
            ? AppColors.primaryOrange
            : AppColors.textHint;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textColor,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      challenge.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stars, color: const Color(0xFFFFA000), size: 14.sp),
                    4.horizontalSpace,
                    Text(
                      '+${challenge.rewardPoints}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB8860B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: challenge.progress,
                    backgroundColor: Colors.grey.shade200,
                    color: progressColor,
                    minHeight: 8.h,
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                '${challenge.completedDays}/${challenge.targetDays}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Empty State ────────────────────────────────────────────
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              color: AppColors.textHint,
              size: 60.sp,
            ),
            24.verticalSpace,
            Text(
              'ابدأ رحلتك الصحية',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            8.verticalSpace,
            Text(
              'سجّل نشاطك اليومي في التوأم الصحي وتابع تحدياتك هنا',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}
