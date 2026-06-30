import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../../data/models/admin_prescription_row.dart';

class AdminPrescriptionReviewForm extends StatefulWidget {
  final AdminPrescriptionRow prescription;
  final bool isSaving;
  final Function(Map<String, dynamic> data) onSave;

  const AdminPrescriptionReviewForm({
    super.key,
    required this.prescription,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<AdminPrescriptionReviewForm> createState() => _AdminPrescriptionReviewFormState();
}

class _AdminPrescriptionReviewFormState extends State<AdminPrescriptionReviewForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStatus;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.prescription.status == 'pending' ? 'approved' : widget.prescription.status;
    _noteCtrl = TextEditingController(text: widget.prescription.note);
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'status': _selectedStatus,
        'note': _noteCtrl.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AdminLocalizations.translate(context, 'review prescription'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          AppDropdown<String>(
            label: AdminLocalizations.translate(context, 'status'),
            value: _selectedStatus,
            items: [
              DropdownMenuItem(value: 'approved', child: Text(AdminLocalizations.translate(context, 'approved'))),
              DropdownMenuItem(value: 'rejected', child: Text(AdminLocalizations.translate(context, 'rejected'))),
              DropdownMenuItem(value: 'pending', child: Text(AdminLocalizations.translate(context, 'pending'))),
            ],
            onChanged: (val) => setState(() => _selectedStatus = val),
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _noteCtrl,
            label: AdminLocalizations.translate(context, 'admin note'),
            hint: AdminLocalizations.translate(context, 'add instructions or reason for rejection...'),
            maxLines: 4,
          ),
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(AdminLocalizations.translate(context, 'confirm review')),
          ),
        ],
      ),
    );
  }
}
