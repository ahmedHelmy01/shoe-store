import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view_model/medical_services_providers.dart';
import 'package:erp/modules/webstore/medical_services/data/models/medication_reminder_model.dart';

class MedicationRemindersView extends ConsumerWidget {
  const MedicationRemindersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReminderSheet(context, ref),
        backgroundColor: AppColors.primaryOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'تذكير جديد',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: remindersAsync.when(
        data: (reminders) =>
        reminders.isNotEmpty
            ? ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            return AppAnimation.fadeInUp(
              delay: Duration(milliseconds: index * 100),
              child: _buildReminderCard(reminders[index], isDark, ref, context),
            );
          },
        )
            : _buildEmptyState(isDark, context, ref),
        loading: () =>
            Center(
              child: CircularProgressIndicator(color: AppColors.primaryOrange),
            ),
        error: (_, __) => _buildEmptyState(isDark, context, ref),
      ),
    );
  }

  Widget _buildReminderCard(MedicationReminderModel reminder,
      bool isDark,
      WidgetRef ref,
      BuildContext context,) {
    return Dismissible(
      key: Key('reminder_${reminder.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete, color: Colors.white, size: 28.sp),
      ),
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: Text('حذف التذكير'),
                content: Text('هل أنت متأكد من حذف هذا التذكير؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(
                        'حذف', style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
        );
      },
      onDismissed: (_) {
        ref.read(medicationRemindersProvider.notifier).deleteReminder(
            reminder.id);
      },
      child: Container(
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
                        AppColors.primaryOrange,
                        AppColors.primaryOrange.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.medication_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
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
                      Text(
                        '${reminder.dosage} • ${reminder.frequency}',
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
                    color: reminder.isActive
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.textHint.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    reminder.isActive ? 'نشط' : 'متوقف',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: reminder.isActive ? AppColors.success : AppColors
                          .textHint,
                    ),
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            // Schedule Times
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: reminder.times.map((time) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.primaryOrange,
                        size: 14.sp,
                      ),
                      4.horizontalSpace,
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            10.verticalSpace,
            // Adherence Bar & Action Button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نسبة الالتزام',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      4.verticalSpace,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: reminder.adherenceRate,
                          backgroundColor: Colors.grey.shade200,
                          color: reminder.adherenceRate > 0.7
                              ? AppColors.success
                              : reminder.adherenceRate > 0.4
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
                  '${(reminder.adherenceRate * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: reminder.adherenceRate > 0.7
                        ? AppColors.success
                        : reminder.adherenceRate > 0.4
                        ? AppColors.warning
                        : AppColors.error,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(medicationRemindersProvider.notifier).markTaken(reminder.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم تسجيل الجرعة لـ ${reminder.medicationName} 👏'),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: const BorderSide(color: AppColors.success, width: 1.2),
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                icon: Icon(Icons.check_circle_outline_rounded, size: 18.sp),
                label: Text(
                  'تم أخذ الجرعة 💊',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, BuildContext context, WidgetRef ref) {
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
              'أضف تذكيرات لأدويتك ومش هتنساها تاني',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton.icon(
              onPressed: () => _showAddReminderSheet(context, ref),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'أضف تذكير',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReminderSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _AddReminderSheet(
        onAdd: (data) {
          Navigator.pop(sheetContext);
          ref.read(medicationRemindersProvider.notifier).addReminder(data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ تم إضافة تذكير ${data['medication_name']} بنجاح'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}

class _AddReminderSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const _AddReminderSheet({required this.onAdd});

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  String _frequency = 'يومياً';
  List<TimeOfDay> _selectedTimes = [];
  String? _timeError;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimes.isNotEmpty
          ? _selectedTimes.last
          : TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryOrange,
                onPrimary: Colors.white,
                onSurface: Colors.black87,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _timeError = null;
        if (!_selectedTimes.any((t) => t.hour == picked.hour && t.minute == picked.minute)) {
          _selectedTimes.add(picked);
        }
      });
    }
  }

  String _formatTimeDisplay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'صباحاً' : 'مساءً';
    return '$hour:$minute $period';
  }

  String _formatTimeApi(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.scaffoldBackgroundColor : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Grab Handle Bar
              Center(
                child: Container(
                  width: 44.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
              16.verticalSpace,

              // Header Section
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.alarm_add_rounded,
                      color: AppColors.primaryOrange,
                      size: 26.sp,
                    ),
                  ),
                  14.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تذكير دواء جديد',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textColor,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          'أدخل اسم الدواء والجرعة وأوقات التنبيه',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
              20.verticalSpace,

              // 1. Medication Name Input
              Text(
                'اسم الدواء *',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
              8.verticalSpace,
              TextFormField(
                controller: _nameController,
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'برجاء كتابة اسم الدواء' : null,
                style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: 'مثال: بنادول إكسترا',
                  hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.medication_outlined, color: AppColors.primaryOrange),
                  filled: true,
                  fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
                  ),
                ),
              ),
              16.verticalSpace,

              // 2. Dosage Input
              Text(
                'الجرعة (اختياري)',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
              8.verticalSpace,
              TextFormField(
                controller: _dosageController,
                style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: 'مثال: قرص واحد بعد الأكل',
                  hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
                  prefixIcon: const Icon(Icons.pie_chart_outline_rounded, color: AppColors.primaryOrange),
                  filled: true,
                  fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
                  ),
                ),
              ),
              16.verticalSpace,

              // 3. Frequency Dropdown
              Text(
                'معدل التكرار',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textColor,
                ),
              ),
              8.verticalSpace,
              DropdownButtonFormField<String>(
                value: _frequency,
                style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black87),
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.repeat_rounded, color: AppColors.primaryOrange),
                  filled: true,
                  fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
                  ),
                ),
                items: ['يومياً', 'مرتين يومياً', '3 مرات يومياً', 'أسبوعياً', 'عند الحاجة']
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) => setState(() => _frequency = v ?? _frequency),
              ),
              20.verticalSpace,

              // 4. Time Selection Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'أوقات التنبيه *',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textColor,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.add_alarm_rounded, color: AppColors.primaryOrange, size: 18),
                    label: Text(
                      'إضافة وقت',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
              8.verticalSpace,

              // Selected Time Chips or Empty Placeholder
              if (_selectedTimes.isEmpty)
                GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: _timeError != null
                          ? AppColors.error.withValues(alpha: 0.05)
                          : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: _timeError != null
                            ? AppColors.error
                            : (isDark ? Colors.white10 : Colors.grey.shade300),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: _timeError != null ? AppColors.error : AppColors.primaryOrange,
                          size: 20.sp,
                        ),
                        8.horizontalSpace,
                        Text(
                          _timeError ?? 'اضغط هنا لاختيار وقت التنبيه',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: _timeError != null ? AppColors.error : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _selectedTimes.map((time) {
                    return Chip(
                      avatar: const Icon(Icons.access_time_rounded, color: AppColors.primaryOrange, size: 16),
                      label: Text(
                        _formatTimeDisplay(time),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.1),
                      deleteIcon: const Icon(Icons.cancel_rounded, size: 16),
                      deleteIconColor: AppColors.primaryOrange,
                      onDeleted: () {
                        setState(() {
                          _selectedTimes.remove(time);
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(color: AppColors.primaryOrange.withValues(alpha: 0.2)),
                      ),
                    );
                  }).toList(),
                ),
              24.verticalSpace,

              // 5. Submit Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final isFormValid = _formKey.currentState!.validate();
                    if (_selectedTimes.isEmpty) {
                      setState(() {
                        _timeError = 'يرجى اختيار وقت واحد على الأقل للتذكير';
                      });
                    }
                    if (isFormValid && _selectedTimes.isNotEmpty) {
                      final timeStrings = _selectedTimes.map(_formatTimeApi).toList();
                      widget.onAdd({
                        'medication_name': _nameController.text.trim(),
                        'dosage': _dosageController.text.trim().isEmpty
                            ? 'جرعة واحدة'
                            : _dosageController.text.trim(),
                        'frequency': _frequency,
                        'times': timeStrings,
                        'start_date': DateTime.now().toIso8601String(),
                        'is_active': true,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                  label: Text(
                    'حفظ التذكير وتفعيل الإشعارات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
