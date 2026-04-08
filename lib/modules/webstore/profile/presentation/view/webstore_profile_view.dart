import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_button/app_button.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_data_field.dart';
import 'widgets/profile_info_section.dart';

class WebStoreProfileView extends StatefulWidget {
  const WebStoreProfileView({super.key});

  @override
  State<WebStoreProfileView> createState() => _WebStoreProfileViewState();
}

class _WebStoreProfileViewState extends State<WebStoreProfileView> {
  bool isEditing = false;
  
  // Mock Controllers
  final nameController = TextEditingController(text: 'Ahmed Mohamed');
  final emailController = TextEditingController(text: 'ahmed.mo@example.com');
  final phoneController = TextEditingController(text: '+20 123 456 7890');
  final addressController = TextEditingController(text: '123 El-Nasr St, Maadi, Cairo');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        titleText: 'My Account',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () => setState(() => isEditing = !isEditing),
            icon: Icon(
              isEditing ? Icons.close_rounded : Icons.edit_note_rounded,
              color: isEditing ? Colors.red : AppColors.primaryOrange,
              size: 28.sp,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // ─── Profile Header ────────────────────────
            AppAnimation.fadeInDown(
              child: ProfileHeader(
                name: nameController.text,
                email: emailController.text,
                isEditing: isEditing,
              ),
            ),
            
            32.verticalSpace,

            // ─── Personal Information Card ──────────────
            ProfileInfoSection(
              title: 'Personal Information',
              children: [
                ProfileDataField(
                  label: 'Full Name',
                  controller: nameController,
                  icon: Icons.person_outline,
                  isEditing: isEditing,
                ),
                ProfileDataField(
                  label: 'Email Address',
                  controller: emailController,
                  icon: Icons.email_outlined,
                  isEditing: isEditing,
                ),
                ProfileDataField(
                  label: 'Phone Number',
                  controller: phoneController,
                  icon: Icons.phone_outlined,
                  isEditing: isEditing,
                ),
              ],
            ),
            
            20.verticalSpace,

            // ─── Address Card ──────────────────────────
            ProfileInfoSection(
              title: 'Location',
              children: [
                ProfileDataField(
                  label: 'Home Address',
                  controller: addressController,
                  icon: Icons.location_on_outlined,
                  isEditing: isEditing,
                  isLast: true,
                ),
              ],
            ),
            
            40.verticalSpace,

            // ─── Save Button ───────────────────────────
            if (isEditing)
              AppAnimation.fadeInUp(
                child: AppButton(
                  onPressed: () => setState(() => isEditing = false),
                  isGradient: true,
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
