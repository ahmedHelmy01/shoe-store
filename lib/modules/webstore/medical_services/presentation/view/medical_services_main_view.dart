import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view/widgets/medical_feature_card.dart';

class MedicalServicesMainView extends ConsumerWidget {
  const MedicalServicesMainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return WebStoreBaseScaffold(
      title: Text(
        'خدمتنا الطبية',
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
            // Hero Header
            _buildHeroHeader(context, isDark),
            24.verticalSpace,

            // Quick Health Status
            _buildHealthStatusBar(context, isDark, ref),
            24.verticalSpace,

            // Feature Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'اختر الخدمة',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
            ),
            12.verticalSpace,
            _buildFeatureGrid(context, isDark),
            24.verticalSpace,

            // AI Assistant Floating Button
            _buildAiAssistantBanner(context, isDark, ref),
            80.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, bool isDark) {
    return AppAnimation.fadeInDown(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF1A237E),
                    const Color(0xFF0D47A1),
                  ]
                : [
                    const Color(0xFF465CA7),
                    const Color(0xFF1A73E8),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32.r),
            bottomRight: Radius.circular(32.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خدمتنا الطبية السريعة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        'صحة أقوى مع الذكاء الاصطناعي',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.amber,
                    size: 18.sp,
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      'مدعوم بالذكاء الاصطناعي المتقدم',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthStatusBar(BuildContext context, bool isDark, WidgetRef ref) {
    return AppAnimation.fadeInUp(
      delay: const Duration(milliseconds: 100),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildHealthStatItem(
              context,
              icon: Icons.favorite_rounded,
              label: 'الحالة',
              value: 'ممتاز',
              color: AppColors.success,
              isDark: isDark,
            ),
            Container(
              width: 1,
              height: 40.h,
              color: isDark ? Colors.white24 : Colors.grey.shade200,
            ),
            _buildHealthStatItem(
              context,
              icon: Icons.bolt_rounded,
              label: 'نقاط',
              value: '1,250',
              color: AppColors.primaryOrange,
              isDark: isDark,
            ),
            Container(
              width: 1,
              height: 40.h,
              color: isDark ? Colors.white24 : Colors.grey.shade200,
            ),
            _buildHealthStatItem(
              context,
              icon: Icons.local_fire_department_rounded,
              label: 'سلسلة',
              value: '12 يوم',
              color: AppColors.boldOrange,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22.sp),
          4.verticalSpace,
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textColor,
            ),
          ),
          2.verticalSpace,
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, bool isDark) {
    final features = [
      MedicalFeatureData(
        title: 'مساعد الأعراض',
        subtitle: 'حلل أعراضك بالذكاء الاصطناعي',
        icon: Icons.psychology_rounded,
        gradient: const [Color(0xFF6C63FF), Color(0xFF3F3D99)],
        route: AppRouteNames.medicalSymptomChat,
      ),
      MedicalFeatureData(
        title: 'مسح صحي ذكي',
        subtitle: 'صوّر واعرف حالتك الصحية',
        icon: Icons.document_scanner_rounded,
        gradient: const [Color(0xFF00BCD4), Color(0xFF00838F)],
        route: AppRouteNames.medicalHealthScanner,
      ),
      MedicalFeatureData(
        title: 'التوأم الصحي',
        subtitle: 'تنبؤات صحية مخصصة ليك',
        icon: Icons.accessibility_new_rounded,
        gradient: const [Color(0xFFE91E63), Color(0xFFAD1457)],
        route: AppRouteNames.medicalHealthTwin,
      ),
      MedicalFeatureData(
        title: 'تذكيرات الأدوية',
        subtitle: 'ذكية ومتابعة التزامك',
        icon: Icons.notifications_active_rounded,
        gradient: const [Color(0xFFFF9800), Color(0xFFE65100)],
        route: AppRouteNames.medicalReminders,
      ),
      MedicalFeatureData(
        title: 'طب عن بُعد',
        subtitle: 'تواصل مع دكتور مباشرة',
        icon: Icons.video_call_rounded,
        gradient: const [Color(0xFF4CAF50), Color(0xFF2E7D32)],
        route: AppRouteNames.medicalTelemedicine,
      ),
      MedicalFeatureData(
        title: 'المحفظة الصحية',
        subtitle: 'بياناتك الصحية في مكان واحد',
        icon: Icons.health_and_safety_rounded,
        gradient: const [Color(0xFF2196F3), Color(0xFF0D47A1)],
        route: AppRouteNames.medicalHealthWallet,
      ),
      MedicalFeatureData(
        title: 'تحدي الصحة',
        subtitle: 'اكسب نقاط مع العادات الصحية',
        icon: Icons.emoji_events_rounded,
        gradient: const [Color(0xFFFFD700), Color(0xFFFFA000)],
        route: AppRouteNames.medicalGamification,
      ),
      MedicalFeatureData(
        title: 'فحص الأدوية AR',
        subtitle: 'اكتشف تفاعلات الأدوية',
        icon: Icons.view_in_ar_rounded,
        gradient: const [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
        route: AppRouteNames.medicalArCheck,
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.85,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return AppAnimation.fadeZoomIn(
            delay: Duration(milliseconds: 200 + (index * 100)),
            child: MedicalFeatureCard(
              feature: feature,
              isDark: isDark,
              onTap: () {
                AppNavigator.push(context, feature.route);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAiAssistantBanner(BuildContext context, bool isDark, WidgetRef ref) {
    return AppAnimation.fadeInUp(
      delay: const Duration(milliseconds: 900),
      child: GestureDetector(
        onTap: () {
          AppNavigator.push(context, AppRouteNames.medicalSymptomChat);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1A237E), const Color(0xFF283593)]
                  : [const Color(0xFF6C63FF), const Color(0xFF3F3D99)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اسأل المساعد الطبي الذكي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'وصّفلك أعراضك واحصل على تحليل فوري',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha: 0.7),
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
