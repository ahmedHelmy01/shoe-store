import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view_model/medical_services_providers.dart';

class TelemedicineView extends ConsumerWidget {
  const TelemedicineView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final doctorsAsync = ref.watch(telemedicineDoctorsProvider);

    return WebStoreBaseScaffold(
      title: Text(
        'طب عن بُعد',
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

            // Live Status Banner
            _buildLiveBanner(isDark),
            20.verticalSpace,

            // Specialty Filter
            _buildSpecialtyFilter(isDark, ref),
            20.verticalSpace,

            // Available Doctors
            Text(
              'الدكتوراه المتاحين',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            12.verticalSpace,

            doctorsAsync.when(
              data: (doctors) => doctors.isNotEmpty
                  ? Column(
                      children: doctors.asMap().entries.map((entry) {
                        return AppAnimation.fadeInUp(
                          delay: Duration(milliseconds: entry.key * 100),
                          child: _buildDoctorCard(entry.value, isDark, context),
                        );
                      }).toList(),
                    )
                  : _buildNoDoctors(isDark),
              loading: () => Column(
                children: List.generate(3, (i) => _buildShimmerDoctor(isDark)),
              ),
              error: (_, __) => _buildNoDoctors(isDark),
            ),
            80.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildLiveBanner(bool isDark) {
    return AppAnimation.fadeInDown(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
                : [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.video_call_rounded,
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
                    'استشارة فورية',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'تواصل مع دكتور في ثواني',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  6.horizontalSpace,
                  Text(
                    'متاح',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
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

  Widget _buildSpecialtyFilter(bool isDark, WidgetRef ref) {
    final specialties = [
      ('الكل', Icons.medical_services, const Color(0xFF6C63FF)),
      ('باطنية', Icons.favorite, AppColors.error),
      ('جلدية', Icons.face, AppColors.primaryOrange),
      ('عامة', Icons.person, AppColors.info),
      ('أسنان', Icons.emoji_food_beverage, const Color(0xFF4CAF50)),
      ('عيون', Icons.visibility, const Color(0xFF9C27B0)),
    ];

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specialties.length,
        separatorBuilder: (_, __) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          final spec = specialties[index];
          return GestureDetector(
            onTap: () {
              final specialty = spec.$1 == 'الكل' ? null : spec.$1;
              ref.read(telemedicineDoctorsProvider.notifier).filterBySpecialty(specialty);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(spec.$2, color: spec.$3, size: 16.sp),
                  6.horizontalSpace,
                  Text(
                    spec.$1,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorCard(TelemedicineDoctor doctor, bool isDark, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                child: doctor.avatar != null
                    ? ClipOval(
                        child: Image.network(
                          doctor.avatar!,
                          width: 56.r,
                          height: 56.r,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: const Color(0xFF6C63FF),
                        size: 28.sp,
                      ),
              ),
              if (doctor.isAvailable)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
                2.verticalSpace,
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14.sp),
                    4.horizontalSpace,
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : AppColors.textColor,
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      '${doctor.consultationFee.toStringAsFixed(0)} ج.م',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Call Button
          GestureDetector(
            onTap: doctor.isAvailable
                ? () => _startSession(context, doctor)
                : null,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                gradient: doctor.isAvailable
                    ? LinearGradient(
                        colors: [AppColors.success, AppColors.success.withValues(alpha: 0.7)],
                      )
                    : null,
                color: doctor.isAvailable ? null : AppColors.textHint.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.videocam_rounded,
                color: doctor.isAvailable ? Colors.white : AppColors.textHint,
                size: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDoctors(bool isDark) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          children: [
            Icon(
              Icons.person_off_rounded,
              color: AppColors.textHint,
              size: 60.sp,
            ),
            24.verticalSpace,
            Text(
              'لا يوجد دكتوراه متاحين',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            8.verticalSpace,
            Text(
              'جرّب تاني بعد شوية',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerDoctor(bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      height: 90.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }

  void _startSession(BuildContext context, TelemedicineDoctor doctor) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            16.verticalSpace,
            CircleAvatar(
              radius: 30.r,
              backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.1),
              child: Icon(Icons.person, color: const Color(0xFF6C63FF), size: 30.sp),
            ),
            12.verticalSpace,
            Text(
              doctor.name,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor.specialty,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            8.verticalSpace,
            Text(
              'رسوم الاستشارة: ${doctor.consultationFee.toStringAsFixed(0)} ج.م',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
            ),
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Start video call session
                },
                icon: Icon(Icons.videocam, color: Colors.white),
                label: Text(
                  'بدء الاستشارة',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            12.verticalSpace,
          ],
        ),
      ),
    );
  }
}
