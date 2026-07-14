import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class CustomerPointsAdjustResult {
  final int points;
  final String reason;
  final bool isDeduct;

  const CustomerPointsAdjustResult({
    required this.points,
    required this.reason,
    required this.isDeduct,
  });
}

class CustomerPointsAdjustDialog extends StatefulWidget {
  final dynamic customerId;
  final String customerName;

  const CustomerPointsAdjustDialog({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<CustomerPointsAdjustDialog> createState() => _CustomerPointsAdjustDialogState();
}

class _CustomerPointsAdjustDialogState extends State<CustomerPointsAdjustDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pointsCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  bool _isDeduct = false;

  @override
  void dispose() {
    _pointsCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final points = int.tryParse(_pointsCtrl.text.trim()) ?? 0;
    Navigator.pop(
      context,
      CustomerPointsAdjustResult(
        points: points,
        reason: _reasonCtrl.text.trim(),
        isDeduct: _isDeduct,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AdminLocalizations.translate(context, 'Adjust Points'),
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: AppColors.textColor),
                        ),
                        Text(
                          widget.customerName,
                          style: TextStyle(color: AppColors.textColor.withValues(alpha: 0.5), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isDeduct = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isDeduct ? AppColors.success.withValues(alpha: 0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: !_isDeduct ? AppColors.success : AppColors.textHint.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_circle_outline, color: AppColors.success, size: 20),
                            const SizedBox(width: 8),
                            Text(AdminLocalizations.translate(context, 'Add'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.success)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isDeduct = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isDeduct ? AppColors.error.withValues(alpha: 0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isDeduct ? AppColors.error : AppColors.textHint.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 20),
                            const SizedBox(width: 8),
                            Text(AdminLocalizations.translate(context, 'Deduct'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.error)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _pointsCtrl,
                label: AdminLocalizations.translate(context, 'Points'),
                hint: AdminLocalizations.translate(context, 'Enter number of points'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return AdminLocalizations.translate(context, 'Points is required');
                  final val = int.tryParse(v.trim());
                  if (val == null || val <= 0) return AdminLocalizations.translate(context, 'Points must be greater than 0');
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _reasonCtrl,
                label: AdminLocalizations.translate(context, 'Reason'),
                hint: AdminLocalizations.translate(context, 'Why are you adjusting points?'),
                maxLines: 2,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return AdminLocalizations.translate(context, 'Reason is required');
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: BorderSide(color: AppColors.textHint.withValues(alpha: 0.3)),
                      ),
                      child: Text(AdminLocalizations.translate(context, 'Cancel'), style: TextStyle(color: AppColors.textColor.withValues(alpha: 0.6), fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(AdminLocalizations.translate(context, 'Confirm'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
