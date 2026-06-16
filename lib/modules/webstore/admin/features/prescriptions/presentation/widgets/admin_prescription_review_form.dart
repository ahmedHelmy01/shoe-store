import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_dropdown/app_dropdown.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
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
          const Text(
            'Review Prescription',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          AppDropdown<String>(
            label: 'Status',
            value: _selectedStatus,
            items: const [
              DropdownMenuItem(value: 'approved', child: Text('Approved')),
              DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
            ],
            onChanged: (val) => setState(() => _selectedStatus = val),
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _noteCtrl,
            label: 'Admin Note',
            hint: 'Add instructions or reason for rejection...',
            maxLines: 4,
          ),
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: const Text('Confirm Review'),
          ),
        ],
      ),
    );
  }
}
