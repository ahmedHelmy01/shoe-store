import 'dart:ui';
import 'package:erp/modules/webstore/support/presentation/state/contact_us_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/modules/webstore/support/data/models/contact_request_model.dart';
import 'package:erp/modules/webstore/support/presentation/view_model/contact_us_view_model.dart';

class ContactUsView extends ConsumerStatefulWidget {
  const ContactUsView({super.key});

  @override
  ConsumerState<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends ConsumerState<ContactUsView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = ContactRequestModel(
        name: _nameController.text,
        email: _emailController.text,
        mobile: _phoneController.text,
        subject: _subjectController.text,
        message: _messageController.text,
      );
      ref.read(contactUsVmProvider.notifier).submitContact(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactUsVmProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ─── Listen for success/error ────────────────────────
    ref.listen(contactUsVmProvider, (previous, next) {
      if (next.status == ContactUsStatus.success) {
        _showSuccessDialog();
      } else if (next.status == ContactUsStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? LocaleKeys.common.error.tr(context: context))),
        );
      }
    });

    return Scaffold(
      appBar: CommonAppBar(
        titleText: LocaleKeys.common.contact_us.tr(context: context),
        showBackButton: true,
        onPressBack: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          // ─── Decorative background blobs ────────────────
          if (isDark)
            Positioned(
              top: -100.h,
              right: -50.w,
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryOrange.withValues(alpha: 0.05),
                ),
              ),
            ),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                10.verticalSpace,
                AppAnimation.fadeInUp(
                  child: _buildContactForm(state, theme, isDark),
                ),
                100.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm(ContactUsState state, ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(LocaleKeys.common.name.tr(context: context), theme),
            _buildTextField(_nameController, Icons.person_outline, theme, isDark),
            20.verticalSpace,
            
            _buildLabel(LocaleKeys.common.email.tr(context: context), theme),
            _buildTextField(_emailController, Icons.email_outlined, theme, isDark, keyboardType: TextInputType.emailAddress),
            20.verticalSpace,
            
            _buildLabel(LocaleKeys.common.phone.tr(context: context), theme),
            _buildTextField(_phoneController, Icons.phone_android_outlined, theme, isDark, keyboardType: TextInputType.phone),
            20.verticalSpace,
            
            _buildLabel(LocaleKeys.common.subject.tr(context: context), theme),
            _buildTextField(_subjectController, Icons.subject_rounded, theme, isDark),
            20.verticalSpace,
            
            _buildLabel(LocaleKeys.common.your_message.tr(context: context), theme),
            _buildTextField(_messageController, Icons.chat_bubble_outline, theme, isDark, maxLines: 4),
            40.verticalSpace,
            
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: state.status == ContactUsStatus.loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  elevation: 0,
                ),
                child: state.status == ContactUsStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        LocaleKeys.common.send_message.tr(context: context),
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
      child: Text(
        text,
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7), 
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, 
    IconData icon, 
    ThemeData theme,
    bool isDark, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      validator: (v) => v == null || v.isEmpty ? LocaleKeys.common.field_required.tr(context: context) : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primaryOrange.withValues(alpha: 0.7), size: 20),
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primaryOrange),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: AppAnimation.fadeZoomIn(
            child: Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 80),
                  24.verticalSpace,
                  Text(
                    LocaleKeys.common.sent_successfully.tr(context: context),
                    style: TextStyle(
                      color: theme.textTheme.titleLarge?.color, 
                      fontSize: 20.sp, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.verticalSpace,
                  Text(
                    LocaleKeys.common.contact_thanks.tr(context: context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7), 
                      fontSize: 14.sp,
                    ),
                  ),
                  32.verticalSpace,
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(LocaleKeys.common.ok.tr(context: context)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
