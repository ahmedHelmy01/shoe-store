import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/medical_services/data/models/medication_reminder_model.dart';

/// منتقي الجرعة: وحدة + كمية (كسور للأقراص/الكبسولات، أرقام للوحدات الأخرى).
class DosePickerSheet {
  static Future<DoseAmount?> show(
    BuildContext context, {
    required DoseAmount initial,
  }) {
    return showModalBottomSheet<DoseAmount>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DosePickerSheet(initial: initial),
    );
  }
}

class _DosePickerSheet extends StatefulWidget {
  final DoseAmount initial;

  const _DosePickerSheet({required this.initial});

  @override
  State<_DosePickerSheet> createState() => _DosePickerSheetState();
}

class _DosePickerSheetState extends State<_DosePickerSheet> {
  late DoseUnit _unit;
  late double _amount;
  late final TextEditingController _numberController;
  static const List<double> _fractionOptions = [0.25, 0.5, 0.75, 1, 1.5, 2, 2.5, 3];
  static const List<double> _plainQuick = [1, 2, 3, 5, 10, 15, 20, 25, 50, 100, 250, 500];

  @override
  void initState() {
    super.initState();
    _unit = widget.initial.unit;
    _amount = widget.initial.amount;
    _numberController = TextEditingController(
      text: _formatNum(widget.initial.amount),
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  static String _formatNum(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 16.h, bottom: 24.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            14.verticalSpace,
            Row(
              children: [
                Icon(Icons.pie_chart_outline_rounded, color: AppColors.primaryOrange, size: 22.sp),
                10.horizontalSpace,
                Text(
                  'الجرعة',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, size: 20.sp, color: isDark ? Colors.white60 : Colors.black54),
                ),
              ],
            ),
            12.verticalSpace,
            Text(
              'الوحدة',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            8.verticalSpace,
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: DoseUnit.values.map((unit) {
                final selected = unit == _unit;
                return ChoiceChip(
                  label: Text(unit.singular),
                  selected: selected,
                  onSelected: (_) => setState(() => _unit = unit),
                  selectedColor: AppColors.primaryOrange.withValues(alpha: 0.15),
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
                    color: selected ? AppColors.primaryOrange : (isDark ? Colors.white70 : AppColors.textSecondary),
                  ),
                );
              }).toList(),
            ),
            16.verticalSpace,
            Text(
              'الكمية',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textColor,
              ),
            ),
            8.verticalSpace,
            if (_unit.isFractional)
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _fractionOptions.map((value) {
                  final dose = DoseAmount(amount: value, unit: _unit);
                  final selected = _amount == value;
                  return ChoiceChip(
                    label: Text(dose.displayLabel),
                    selected: selected,
                    onSelected: (_) => setState(() => _amount = value),
                    selectedColor: AppColors.primaryOrange.withValues(alpha: 0.15),
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
                      color: selected ? AppColors.primaryOrange : (isDark ? Colors.white70 : AppColors.textSecondary),
                    ),
                  );
                }).toList(),
              )
            else ...[
              TextField(
                controller: _numberController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 15.sp, color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  suffixText: _unit.singular,
                  suffixStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
                  ),
                ),
                onChanged: (text) {
                  final v = double.tryParse(text);
                  if (v != null && v > 0) setState(() => _amount = v);
                },
              ),
              12.verticalSpace,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _plainQuick.map((value) {
                  final selected = _amount == value;
                  return ChoiceChip(
                    label: Text(_formatNum(value)),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _amount = value;
                        _numberController.text = _formatNum(value);
                      });
                    },
                    selectedColor: AppColors.primaryOrange.withValues(alpha: 0.15),
                    backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    labelStyle: TextStyle(
                      fontSize: 12.sp,
                      color: selected ? AppColors.primaryOrange : (isDark ? Colors.white70 : AppColors.textSecondary),
                    ),
                  );
                }).toList(),
              ),
            ],
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(
                  context,
                  DoseAmount(amount: _amount, unit: _unit),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                label: Text(
                  'تأكيد الجرعة',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
