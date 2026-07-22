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
            // Adherence Bar
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) =>
          _AddReminderSheet(
            onAdd: (data) {
              ref.read(medicationRemindersProvider.notifier).addReminder(data);
              Navigator.pop(context);
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
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  String _frequency = 'يومياً';
  final List<String> _times = ['08:00'];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom + 20.h,
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
            'تذكير جديد',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          16.verticalSpace,
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'اسم الدواء',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          12.verticalSpace,
          TextField(
            controller: _dosageController,
            decoration: InputDecoration(
              labelText: 'الجرعة',
              hintText: 'مثال: قرص واحد',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          12.verticalSpace,
          DropdownButtonFormField<String>(
            initialValue: _frequency,
            decoration: InputDecoration(
              labelText: 'التكرار',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            items: ['يومياً', 'مرتين يومياً', '3 مرات يومياً', 'أسبوعياً']
                .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                .toList(),
            onChanged: (v) => setState(() => _frequency = v ?? _frequency),
          ),
          20.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  widget.onAdd({
                    'medication_name': _nameController.text,
                    'dosage': _dosageController.text,
                    'frequency': _frequency,
                    'times': _times,
                    'start_date': DateTime.now().toIso8601String(),
                    'is_active': true,
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'إضافة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
