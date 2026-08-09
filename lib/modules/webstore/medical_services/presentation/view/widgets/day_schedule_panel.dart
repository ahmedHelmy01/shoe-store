import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/medical_services/data/models/medication_reminder_model.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view_model/medication_reminders_providers.dart';

/// عرض جدول يوم محدد: كل الأدوية ومواعيدها وجرعاتها وطرق أخذها،
/// مع إمكانية تسجيل أخذ الجرعة.
class DaySchedulePanel extends ConsumerWidget {
  final DateTime date;
  final List<MedicationReminderModel> reminders;

  const DaySchedulePanel({super.key, required this.date, required this.reminders});

  static const List<Color> _medColors = [
    AppColors.primaryOrange,
    Color(0xFF4C9F70),
    Color(0xFF5B7BD5),
    Color(0xFF9B59B6),
    Color(0xFFE67E22),
    Color(0xFF16A085),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = DateTime(date.year, date.month, date.day) == today;

    // الأدوية المجدولة في هذا اليوم مع مواعيدها مرتبة
    final entries = <_DayEntry>[];
    for (final reminder in reminders) {
      for (final slot in reminder.slotsFor(date.weekday)) {
        entries.add(_DayEntry(reminder, slot));
      }
    }
    entries.sort((a, b) =>
        (a.slot.hour * 60 + a.slot.minute).compareTo(b.slot.hour * 60 + b.slot.minute));

    if (entries.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy_rounded, color: AppColors.textHint, size: 42.sp),
            12.verticalSpace,
            Text(
              'لا توجد أدوية مجدولة في هذا اليوم',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    // تجميع حسب الخطة/الحالة
    final groups = <String?, List<_DayEntry>>{};
    for (final entry in entries) {
      groups.putIfAbsent(entry.reminder.conditionName, () => []).add(entry);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in groups.entries) ...[
          if (group.key != null && group.key!.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.folder_rounded, size: 14.sp, color: AppColors.primaryOrange),
                6.horizontalSpace,
                Text(
                  group.key!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
            6.verticalSpace,
          ],
          ...group.value.map((entry) => _buildEntryCard(entry, isDark, isToday, ref, context)),
          10.verticalSpace,
        ],
      ],
    );
  }

  Widget _buildEntryCard(
    _DayEntry entry,
    bool isDark,
    bool isToday,
    WidgetRef ref,
    BuildContext context,
  ) {
    final reminder = entry.reminder;
    final slot = entry.slot;
    final occurrence = slot.nextOccurrenceOn(date);
    final isFuture = occurrence.isAfter(DateTime.now());
    final taken = reminder.isTakenOn(occurrence);
    final color = _medColors[reminder.id % _medColors.length];
    final muted = !reminder.isActive;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: muted ? 0.02 : 0.05)
            : (muted ? Colors.grey.shade100 : Colors.white),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: taken
              ? AppColors.success.withValues(alpha: 0.4)
              : (isDark ? Colors.white10 : Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42.w,
                padding: EdgeInsets.symmetric(vertical: 6.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    Icon(Icons.access_time_rounded, size: 13.sp, color: color),
                    2.verticalSpace,
                    Text(
                      slot.timeLabel,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.medicationName,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    3.verticalSpace,
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: [
                        _miniChip(
                          icon: Icons.pie_chart_outline_rounded,
                          label: slot.dose.displayLabel,
                          color: AppColors.primaryOrange,
                        ),
                        _miniChip(
                          icon: Icons.medical_services_outlined,
                          label: slot.method.label,
                          color: AppColors.primaryBlue,
                        ),
                        if (!reminder.isActive)
                          _miniChip(
                            icon: Icons.pause_circle_outline_rounded,
                            label: 'متوقف',
                            color: AppColors.textHint,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (taken)
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: AppColors.success, size: 20),
                )
              else if (!isFuture && isToday)
                InkWell(
                  onTap: () {
                    ref.read(medicationRemindersProvider.notifier).markTaken(
                          reminder.id,
                          scheduledFor: occurrence,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم تسجيل جرعة ${reminder.medicationName} 👏'),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.success, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 14.sp, color: AppColors.success),
                        4.horizontalSpace,
                        Text(
                          'تسجيل',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (isFuture)
                Icon(Icons.hourglass_empty_rounded, color: AppColors.textHint, size: 20.sp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: color),
          4.horizontalSpace,
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

class _DayEntry {
  final MedicationReminderModel reminder;
  final MedicationTimeSlot slot;

  const _DayEntry(this.reminder, this.slot);
}
