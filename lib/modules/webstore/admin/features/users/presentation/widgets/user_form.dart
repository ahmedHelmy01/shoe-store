import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../../data/models/user_row.dart';

class UserForm extends StatefulWidget {
  final UserRow? initial;
  final bool isSaving;
  final Function(Map<String, dynamic>) onSave;

  const UserForm({
    super.key,
    this.initial,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.name);
    _emailController = TextEditingController(text: widget.initial?.email);
    _mobileController = TextEditingController(text: widget.initial?.mobile);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'mobile': _mobileController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _nameController,
            label: AdminLocalizations.translate(context, 'full name'),
            hint: AdminLocalizations.translate(context, 'enter user name'),
            validator: (v) => v == null || v.isEmpty ? AdminLocalizations.translate(context, 'name is required') : null,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _emailController,
            label: AdminLocalizations.translate(context, 'email address'),
            hint: 'user@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _mobileController,
            label: AdminLocalizations.translate(context, 'mobile number'),
            hint: '+20 10xxxxxxxx',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 32),
          AppButton(
            onPressed: _submit,
            isLoading: widget.isSaving,
            child: Text(widget.initial == null ? AdminLocalizations.translate(context, 'add user') : AdminLocalizations.translate(context, 'save changes')),
          ),
        ],
      ),
    );
  }
}
