import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/medical_services/data/models/medication_reminder_model.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view/widgets/dose_picker.dart';
import 'package:erp/modules/webstore/medical_services/presentation/view/widgets/method_picker.dart';

/// نموذج موعد داخل النموذج (قبل الحفظ).
class _SlotDraft {
  TimeOfDay time;
  DoseAmount dose;
  AdministrationMethod method;

  _SlotDraft({
    required this.time,
    required this.dose,
    required this.method,
  });
}

/// شيت إضافة / تعديل تذكير دواء بالنمط الأسبوعي المتقدم.
class MedicationPlanSheet extends StatefulWidget {
  final MedicationReminderModel? existing;
  final List<String> existingConditions;
  final void Function(Map<String, dynamic> data) onAdd;
  final void Function(MedicationReminderModel updated) onUpdate;

  const MedicationPlanSheet({
    super.key,
    this.existing,
    required this.existingConditions,
    required this.onAdd,
    required this.onUpdate,
  });

  static Future<void> show(
    BuildContext context, {
    MedicationReminderModel? existing,
    required List<String> existingConditions,
    required void Function(Map<String, dynamic> data) onAdd,
    required void Function(MedicationReminderModel updated) onUpdate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MedicationPlanSheet(
        existing: existing,
        existingConditions: existingConditions,
        onAdd: onAdd,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  State<MedicationPlanSheet> createState() => _MedicationPlanSheetState();
}

class _MedicationPlanSheetState extends State<MedicationPlanSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _conditionController;
  late final TextEditingController _notesController;

  late DateTime _startDate;
  DateTime? _endDate;

  /// weekday (DateTime.*) -> المواعيد المجدولة لذلك اليوم
  final Map<int, List<_SlotDraft>> _drafts = {};

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.medicationName ?? '');
    _conditionController = TextEditingController(text: existing?.conditionName ?? '');
    _notesController = TextEditingController(text: existing?.notes ?? '');
    _startDate = existing?.startDate ?? DateTime.now();

    for (final day in existing?.weeklySchedule ?? const <PlanDaySchedule>[]) {
      if (day.slots.isEmpty) continue;
      _drafts[day.weekday] = day.slots
          .map((s) => _SlotDraft(
                time: TimeOfDay(hour: s.hour, minute: s.minute),
                dose: s.dose,
                method: s.method,
              ))
          .toList();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _conditionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  List<int> get _selectedWeekdays => PlanDaySchedule.weekOrder
      .where((w) => (_drafts[w] ?? []).isNotEmpty)
      .toList();

  // ─── Helpers ─────────────────────────────────────────────

  String _formatDate(DateTime d) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : (_endDate ?? _startDate),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
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
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _pickTime(int weekday, _SlotDraft slot) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: slot.time,
      builder: (context, child) => MediaQuery(
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
      ),
    );
    if (picked != null) {
      setState(() => slot.time = picked);
    }
  }

  Future<void> _pickDose(int weekday, _SlotDraft slot) async {
    final picked = await DosePickerSheet.show(context, initial: slot.dose);
    if (picked != null) {
      setState(() => slot.dose = picked);
    }
  }

  Future<void> _pickMethod(int weekday, _SlotDraft slot) async {
    final picked = await MethodPickerSheet.show(context, initial: slot.method);
    if (picked != null) {
      setState(() => slot.method = picked);
    }
  }

  String _timeLabel(TimeOfDay t) {
    final h12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'صباحاً' : 'مساءً';
    return '$h12:$minute $period';
  }

  // ─── Save ────────────────────────────────────────────────

  void _save() {
    final valid = _formKey.currentState!.validate();
    if (!valid) return;

    if (_selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اختر يومًا واحدًا على الأقل وأضف له موعدًا'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final schedule = PlanDaySchedule.weekOrder.map((weekday) {
      final slots = (_drafts[weekday] ?? []).map((draft) {
        return MedicationTimeSlot(
          hour: draft.time.hour,
          minute: draft.time.minute,
          dose: draft.dose,
          method: draft.method,
        );
      }).toList()
        ..sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
      return PlanDaySchedule(weekday: weekday, slots: slots);
    }).toList();

    final name = _nameController.text.trim();
    final condition = _conditionController.text.trim();
    final notes = _notesController.text.trim();

    if (_isEdit) {
      final existing = widget.existing!;
      widget.onUpdate(existing.copyWith(
        medicationName: name,
        conditionName: condition.isEmpty ? null : condition,
        notes: notes.isEmpty ? null : notes,
        startDate: _startDate,
        endDate: _endDate,
        weeklySchedule: schedule,
      ));
    } else {
      widget.onAdd({
        'medication_name': name,
        'condition_name': condition.isEmpty ? null : condition,
        'notes': notes.isEmpty ? null : notes,
        'start_date': _startDate.toIso8601String(),
        'end_date': _endDate?.toIso8601String(),
        'weekly_schedule': schedule,
      });
    }
    Navigator.pop(context);
  }

  // ─── UI ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final suggestedConditions = widget.existingConditions
        .where((c) => c != widget.existing?.conditionName)
        .toSet()
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.95,
      minChildSize: 0.7,
      maxChildSize: 0.98,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 14.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
            ),
            children: [
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
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      _isEdit ? Icons.edit_calendar_rounded : Icons.alarm_add_rounded,
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
                          _isEdit ? 'تعديل تذكير الدواء' : 'تذكير دواء جديد',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textColor,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          'حدد الجرعات والمواعيد لكل يوم في الأسبوع',
                          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: isDark ? Colors.white60 : Colors.black54),
                  ),
                ],
              ),
              20.verticalSpace,

              // 1) اسم الدواء
              Text('اسم الدواء *', style: _labelStyle(isDark)),
              8.verticalSpace,
              TextFormField(
                controller: _nameController,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'برجاء كتابة اسم الدواء' : null,
                style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black87),
                decoration: _fieldDecoration(
                  hint: 'مثال: بنادول إكسترا',
                  icon: Icons.medication_outlined,
                  isDark: isDark,
                ),
              ),
              16.verticalSpace,

              // 2) الخطة/الحالة
              Text('الخطة / الحالة (اختياري)', style: _labelStyle(isDark)),
              4.verticalSpace,
              Text(
                'مثال: ضغط الدم، سكر، قصور الكبد — لتجميع أدوية الحالة معًا',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
              ),
              8.verticalSpace,
              TextFormField(
                controller: _conditionController,
                style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black87),
                decoration: _fieldDecoration(
                  hint: 'مثال: ضغط الدم',
                  icon: Icons.folder_outlined,
                  isDark: isDark,
                ),
              ),
              if (suggestedConditions.isNotEmpty) ...[
                8.verticalSpace,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: suggestedConditions.map((c) {
                    return ActionChip(
                      avatar: Icon(Icons.folder_rounded, size: 15.sp, color: AppColors.primaryOrange),
                      label: Text(c),
                      onPressed: () => setState(() => _conditionController.text = c),
                      backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.08),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      labelStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryOrange,
                      ),
                    );
                  }).toList(),
                ),
              ],
              16.verticalSpace,

              // 3) تاريخ البدء / الانتهاء
              Row(
                children: [
                  Expanded(
                    child: _dateField(
                      label: 'تاريخ البدء',
                      value: _startDate,
                      onTap: () => _pickDate(isStart: true),
                      isDark: isDark,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: _dateField(
                      label: 'تاريخ الانتهاء (اختياري)',
                      value: _endDate,
                      onTap: () => _pickDate(isStart: false),
                      isDark: isDark,
                      clearable: _endDate != null,
                      onClear: () => setState(() => _endDate = null),
                    ),
                  ),
                ],
              ),
              20.verticalSpace,

              // 4) أيام الأسبوع
              Text('أيام الأسبوع *', style: _labelStyle(isDark)),
              8.verticalSpace,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: PlanDaySchedule.weekOrder.map((weekday) {
                  final slots = _drafts[weekday] ?? [];
                  final selected = slots.isNotEmpty;
                  return FilterChip(
                    avatar: Icon(
                      selected ? Icons.check : Icons.event_available_outlined,
                      size: 15.sp,
                      color: selected ? Colors.white : AppColors.primaryOrange,
                    ),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(PlanDaySchedule.weekdayShortLabel(weekday)),
                        if (selected) ...[
                          6.horizontalSpace,
                          Text('(${slots.length})'),
                        ],
                      ],
                    ),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _drafts[weekday] ??= [
                            _SlotDraft(
                              time: const TimeOfDay(hour: 8, minute: 0),
                              dose: const DoseAmount(amount: 1, unit: DoseUnit.pill),
                              method: AdministrationMethod.afterMeal,
                            ),
                          ];
                        } else {
                          _drafts.remove(weekday);
                        }
                      });
                    },
                    selectedColor: AppColors.primaryOrange,
                    backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                    side: BorderSide(
                      color: selected
                          ? AppColors.primaryOrange
                          : (isDark ? Colors.white12 : Colors.grey.shade300),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    labelStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : (isDark ? Colors.white70 : AppColors.textSecondary),
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              20.verticalSpace,

              // 5) مواعيد الأيام المختارة
              if (_selectedWeekdays.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.schedule_rounded, color: AppColors.primaryOrange, size: 32.sp),
                      8.verticalSpace,
                      Text(
                        'اختر الأيام من الأعلى ثم أضف مواعيدها',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._selectedWeekdays.map((weekday) {
                  final slots = _drafts[weekday]!;
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, color: AppColors.primaryOrange, size: 17.sp),
                            8.horizontalSpace,
                            Text(
                              PlanDaySchedule.weekdayLabel(weekday),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        ...slots.asMap().entries.map((entry) {
                          final i = entry.key;
                          final slot = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                // الوقت
                                Expanded(
                                  flex: 4,
                                  child: _slotButton(
                                    onTap: () => _pickTime(weekday, slot),
                                    icon: Icons.access_time_rounded,
                                    label: _timeLabel(slot.time),
                                    isDark: isDark,
                                  ),
                                ),
                                8.horizontalSpace,
                                // الجرعة
                                Expanded(
                                  flex: 5,
                                  child: _slotButton(
                                    onTap: () => _pickDose(weekday, slot),
                                    icon: Icons.pie_chart_outline_rounded,
                                    label: slot.dose.displayLabel,
                                    isDark: isDark,
                                  ),
                                ),
                                8.horizontalSpace,
                                // طريقة الأخذ
                                Expanded(
                                  flex: 5,
                                  child: _slotButton(
                                    onTap: () => _pickMethod(weekday, slot),
                                    icon: Icons.medical_services_outlined,
                                    label: slot.method.label,
                                    isDark: isDark,
                                  ),
                                ),
                                4.horizontalSpace,
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      slots.removeAt(i);
                                      if (slots.isEmpty) _drafts.remove(weekday);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    size: 20.sp,
                                    color: AppColors.error,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _drafts[weekday]!.add(_SlotDraft(
                                  time: const TimeOfDay(hour: 8, minute: 0),
                                  dose: const DoseAmount(amount: 1, unit: DoseUnit.pill),
                                  method: AdministrationMethod.afterMeal,
                                ));
                              });
                            },
                            icon: Icon(Icons.add_alarm_rounded, size: 17.sp, color: AppColors.primaryOrange),
                            label: Text(
                              'إضافة موعد آخر لهذا اليوم',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryOrange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              20.verticalSpace,

              // 6) ملاحظات
              Text('ملاحظات (اختياري)', style: _labelStyle(isDark)),
              8.verticalSpace,
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                style: TextStyle(fontSize: 14.sp, color: isDark ? Colors.white : Colors.black87),
                decoration: _fieldDecoration(
                  hint: 'مثال: توقف عن الدواء عند حدوث دوخة',
                  icon: Icons.notes_rounded,
                  isDark: isDark,
                ),
              ),
              24.verticalSpace,

              // 7) حفظ
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  ),
                  icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                  label: Text(
                    _isEdit ? 'حفظ التعديلات' : 'حفظ التذكير وتفعيل الإشعارات',
                    style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required bool isDark,
    bool clearable = false,
    VoidCallback? onClear,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, color: AppColors.primaryOrange, size: 16.sp),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.verticalSpace,
                  Text(
                    value == null ? 'غير محدد' : _formatDate(value),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: value == null
                          ? AppColors.textHint
                          : (isDark ? Colors.white : AppColors.textColor),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (clearable)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.cancel_rounded, size: 16.sp, color: AppColors.textHint),
              ),
          ],
        ),
      ),
    );
  }

  Widget _slotButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: AppColors.primaryOrange.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 14.sp),
            3.verticalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryOrange,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle(bool isDark) {
    return TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : AppColors.textColor,
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
      prefixIcon: Icon(icon, color: AppColors.primaryOrange),
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
    );
  }
}
