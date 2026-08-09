import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/modules/webstore/medical_services/data/models/medication_reminder_model.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view/widgets/day_schedule_panel.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view/widgets/medication_plan_sheet.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view_model/medication_reminders_providers.dart';

class MedicationRemindersView extends ConsumerStatefulWidget {
  const MedicationRemindersView({super.key});

  @override
  ConsumerState<MedicationRemindersView> createState() => _MedicationRemindersViewState();
}

class _MedicationRemindersViewState extends ConsumerState<MedicationRemindersView> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;
  bool _showList = false;

  static const List<Color> _medColors = [
    AppColors.primaryOrange,
    Color(0xFF4C9F70),
    Color(0xFF5B7BD5),
    Color(0xFF9B59B6),
    Color(0xFFE67E22),
    Color(0xFF16A085),
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month);
    _selectedDate = now;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remindersAsync = ref.watch(medicationRemindersProvider);

    return WebStoreBaseScaffold(
      title: Text(
        'تذكيرات الأدوية',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      showBack: true,
      extendBodyBehindAppBar: false,
      floatingActionButton: remindersAsync.maybeWhen(
        data: (reminders) => reminders.isEmpty
            ? null
            : FloatingActionButton.extended(
                onPressed: () => _openPlanSheet(context),
                backgroundColor: AppColors.primaryOrange,
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  'تذكير جديد',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
        orElse: () => null,
      ),
      body: remindersAsync.when(
        data: (reminders) {
          if (reminders.isEmpty) return _buildEmptyState(isDark, context);
          return Column(
            children: [
              _buildViewToggle(isDark),
              8.verticalSpace,
              Expanded(
                child: _showList
                    ? _buildPlansList(reminders, isDark, context)
                    : _buildCalendarTab(reminders, isDark, context),
              ),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        ),
        error: (_, _) => _buildEmptyState(isDark, context),
      ),
    );
  }

  // ─── Toggle ──────────────────────────────────────────────

  Widget _buildViewToggle(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            _toggleItem(
              label: 'جدول الشهر',
              icon: Icons.calendar_month_rounded,
              selected: !_showList,
              onTap: () => setState(() => _showList = false),
              isDark: isDark,
            ),
            _toggleItem(
              label: 'خطتي',
              icon: Icons.medication_rounded,
              selected: _showList,
              onTap: () => setState(() => _showList = true),
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 9.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.sp, color: selected ? Colors.white : AppColors.textSecondary),
              6.horizontalSpace,
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Calendar Tab ────────────────────────────────────────

  Widget _buildCalendarTab(
    List<MedicationReminderModel> reminders,
    bool isDark,
    BuildContext context,
  ) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    return Column(
      children: [
        _buildMonthHeader(isDark),
        _buildWeekdayHeader(isDark),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildMonthGrid(reminders, isDark, todayDate, selectedDate),
                8.verticalSpace,
                _buildSelectedDayHeader(selectedDate, isDark),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: DaySchedulePanel(date: selectedDate, reminders: reminders),
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthHeader(bool isDark) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          IconButton(
            onPressed: () => setState(() {
              _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
            }),
            icon: Icon(Icons.chevron_right_rounded, color: AppColors.primaryOrange, size: 26.sp),
          ),
          Expanded(
            child: Text(
              '${months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
            }),
            icon: Icon(Icons.chevron_left_rounded, color: AppColors.primaryOrange, size: 26.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: PlanDaySchedule.weekOrder.map((weekday) {
          return Expanded(
            child: Center(
              child: Text(
                PlanDaySchedule.weekdayShortLabel(weekday),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: weekday == DateTime.friday || weekday == DateTime.saturday
                      ? AppColors.error.withValues(alpha: 0.8)
                      : (isDark ? Colors.white60 : AppColors.textSecondary),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthGrid(
    List<MedicationReminderModel> reminders,
    bool isDark,
    DateTime todayDate,
    DateTime selectedDate,
  ) {
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final leadingBlanks = (firstDay.weekday + 1) % 7; // الأسبوع يبدأ السبت
    final totalCells = ((leadingBlanks + daysInMonth) / 7).ceil() * 7;

    // الأدوية المجدولة لكل يوم في الأسبوع (مرة واحدة)
    final byWeekday = <int, List<MedicationReminderModel>>{};
    for (final weekday in PlanDaySchedule.weekOrder) {
      byWeekday[weekday] = reminders
          .where((r) => r.slotsFor(weekday).isNotEmpty)
          .toList();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 4.h,
          crossAxisSpacing: 4.w,
          childAspectRatio: 0.82,
        ),
        itemCount: totalCells,
        itemBuilder: (context, index) {
          final date = firstDay.subtract(Duration(days: leadingBlanks - index));
          final inMonth = date.month == _displayedMonth.month;
          final isToday = date == todayDate;
          final isSelected = date == selectedDate;
          final meds = inMonth
              ? (byWeekday[date.weekday] ?? const <MedicationReminderModel>[])
              : const <MedicationReminderModel>[];
          return _buildDayCell(
            date: date,
            inMonth: inMonth,
            isToday: isToday,
            isSelected: isSelected,
            meds: meds,
            isDark: isDark,
          );
        },
      ),
    );
  }

  Widget _buildDayCell({
    required DateTime date,
    required bool inMonth,
    required bool isToday,
    required bool isSelected,
    required List<MedicationReminderModel> meds,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () => setState(() => _selectedDate = date),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryOrange.withValues(alpha: 0.12)
              : isToday
                  ? AppColors.primaryOrange.withValues(alpha: 0.07)
                  : null,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryOrange
                : isToday
                    ? AppColors.primaryOrange.withValues(alpha: 0.4)
                    : Colors.transparent,
            width: 1.2,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                color: !inMonth
                    ? AppColors.textHint.withValues(alpha: 0.5)
                    : isToday
                        ? AppColors.primaryOrange
                        : (isDark ? Colors.white : AppColors.textColor),
              ),
            ),
            4.verticalSpace,
            if (meds.isNotEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (meds.length <= 3)
                      ...meds.map((m) {
                        final color = _medColors[m.id % _medColors.length];
                        return Container(
                          width: 16.w,
                          height: 4.h,
                          margin: EdgeInsets.only(bottom: 2.h),
                          decoration: BoxDecoration(
                            color: m.isActive
                                ? color
                                : color.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        );
                      })
                    else ...[
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 2.h,
                        children: meds.take(3).map((m) {
                          final color = _medColors[m.id % _medColors.length];
                          return Container(
                            width: 5.w,
                            height: 5.w,
                            decoration: BoxDecoration(
                              color: m.isActive ? color : color.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                      2.verticalSpace,
                      Text(
                        '+${meds.length - 3}',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDayHeader(DateTime date, bool isDark) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    final today = DateTime.now();
    final isToday = DateTime(date.year, date.month, date.day) ==
        DateTime(today.year, today.month, today.day);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              isToday ? Icons.today_rounded : Icons.event_rounded,
              color: AppColors.primaryOrange,
              size: 18.sp,
            ),
          ),
          10.horizontalSpace,
          Text(
            isToday
                ? 'جدول اليوم'
                : 'جدول ${PlanDaySchedule.weekdayLabel(date.weekday)} ${date.day} ${months[date.month - 1]}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Plans List Tab ───────────────────────────────────────

  Widget _buildPlansList(
    List<MedicationReminderModel> reminders,
    bool isDark,
    BuildContext context,
  ) {
    // تجميع حسب الخطة/الحالة
    final grouped = <String?, List<MedicationReminderModel>>{};
    for (final r in reminders) {
      grouped.putIfAbsent(r.conditionName, () => []).add(r);
    }
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => (a ?? '~').compareTo(b ?? '~'));

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        for (final key in sortedKeys) ...[
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Icon(
                  key == null ? Icons.medication_rounded : Icons.folder_rounded,
                  size: 15.sp,
                  color: AppColors.primaryOrange,
                ),
                6.horizontalSpace,
                Text(
                  key ?? 'أدوية بدون خطة',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: key == null ? AppColors.textSecondary : AppColors.primaryOrange,
                  ),
                ),
                const Spacer(),
                Text(
                  '${grouped[key]!.length}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          ...grouped[key]!.map(
            (r) => _buildPlanCard(r, isDark, context),
          ),
          8.verticalSpace,
        ],
      ],
    );
  }

  Widget _buildPlanCard(
    MedicationReminderModel reminder,
    bool isDark,
    BuildContext context,
  ) {
    final adherence = reminder.adherenceRate;
    final days = reminder.scheduledWeekdays;

    return Dismissible(
      key: Key('reminder_${reminder.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete, color: Colors.white, size: 28.sp),
      ),
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('حذف التذكير'),
            content: const Text('هل أنت متأكد من حذف هذا التذكير؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('حذف', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(medicationRemindersProvider.notifier).deleteReminder(reminder.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف التذكير'), duration: Duration(seconds: 2)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _medColors[reminder.id % _medColors.length],
                        _medColors[reminder.id % _medColors.length].withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.medication_rounded, color: Colors.white, size: 20.sp),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.medicationName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textColor,
                        ),
                      ),
                      if (reminder.conditionName != null && reminder.conditionName!.isNotEmpty)
                        3.verticalSpace,
                      if (reminder.conditionName != null && reminder.conditionName!.isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.folder_rounded, size: 12.sp, color: AppColors.primaryOrange),
                            4.horizontalSpace,
                            Flexible(
                              child: Text(
                                reminder.conditionName!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.primaryOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: reminder.isActive,
                  onChanged: (_) {
                    ref.read(medicationRemindersProvider.notifier).toggleActive(reminder.id);
                  },
                  activeTrackColor: AppColors.success,
                  activeThumbColor: Colors.white,
                  inactiveThumbColor: AppColors.textHint,
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, size: 20.sp, color: AppColors.textSecondary),
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  onSelected: (value) {
                    if (value == 'edit') _openPlanSheet(context, existing: reminder);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('تعديل التذكير')),
                  ],
                ),
              ],
            ),
            12.verticalSpace,
            // أيام الأسبوع المحددة
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: days.map((weekday) {
                final slots = reminder.slotsFor(weekday);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time, color: AppColors.primaryOrange, size: 12.sp),
                      4.horizontalSpace,
                      Text(
                        '${PlanDaySchedule.weekdayShortLabel(weekday)} ×${slots.length}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (reminder.notes != null && reminder.notes!.isNotEmpty) ...[
              8.verticalSpace,
              Text(
                reminder.notes!,
                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نسبة الالتزام',
                        style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                      ),
                      4.verticalSpace,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: adherence,
                          backgroundColor: Colors.grey.shade200,
                          color: adherence > 0.7
                              ? AppColors.success
                              : adherence > 0.4
                                  ? AppColors.warning
                                  : AppColors.error,
                          minHeight: 6.h,
                        ),
                      ),
                    ],
                  ),
                ),
                12.horizontalSpace,
                Text(
                  '${(adherence * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: adherence > 0.7
                        ? AppColors.success
                        : adherence > 0.4
                            ? AppColors.warning
                            : AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty State ─────────────────────────────────────────

  Widget _buildEmptyState(bool isDark, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primaryOrange,
                size: 60.sp,
              ),
            ),
            24.verticalSpace,
            Text(
              'لا توجد تذكيرات بعد',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            8.verticalSpace,
            Text(
              'أضف أدويتك مع جدولها الأسبوعي — كل يوم له جرعته وطريقة تناوله',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton.icon(
              onPressed: () => _openPlanSheet(context),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'أضف تذكير',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Add / Edit Sheet ────────────────────────────────────

  void _openPlanSheet(BuildContext context, {MedicationReminderModel? existing}) {
    final reminders = ref.read(medicationRemindersProvider).value ?? [];
    final conditions = reminders
        .map((r) => r.conditionName ?? '')
        .where((c) => c.isNotEmpty)
        .toList();

    MedicationPlanSheet.show(
      context,
      existing: existing,
      existingConditions: conditions,
      onAdd: (data) {
        ref.read(medicationRemindersProvider.notifier).addReminder(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ تم إضافة تذكير ${data['medication_name']} بنجاح'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      onUpdate: (updated) {
        ref.read(medicationRemindersProvider.notifier).updateReminder(updated);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ تم تحديث تذكير ${updated.medicationName}'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}
