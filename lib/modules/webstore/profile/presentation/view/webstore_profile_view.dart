import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_providers.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_data_field.dart';
import 'widgets/profile_info_section.dart';
import 'widgets/profile_points_card.dart';
import 'widgets/profile_action_buttons.dart';

class WebStoreProfileView extends ConsumerStatefulWidget {
  const WebStoreProfileView({super.key});

  @override
  ConsumerState<WebStoreProfileView> createState() => _WebStoreProfileViewState();
}

class _WebStoreProfileViewState extends ConsumerState<WebStoreProfileView> {
  bool isEditing = false;
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final state = ref.read(webStoreAuthViewModelProvider);
      if (state is WebStoreAuthSuccess) {
        setState(() => _populateFields(state.authResponse.user));
      } else {
        ref.read(webStoreAuthViewModelProvider.notifier).getProfile();
      }
    });
  }

  void _populateFields(user) {
    nameController.text = user.name;
    emailController.text = user.email ?? '';
    phoneController.text = user.mobile ?? '';
    addressController.text = user.address ?? '';
    _selectedBranchId = user.branchId;
  }

  int? _selectedBranchId;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _onSave() {
    ref.read(webStoreAuthViewModelProvider.notifier).updateProfile(
      name: nameController.text,
      email: emailController.text,
      mobile: phoneController.text,
    );
  }

  void _onDeleteAccount() {
    AppStatusDialog.show(
      context,
      status: AppDialogStatus.error,
      title: LocaleKeys.webstore.profile.delete_account.tr(context: context),
      message: LocaleKeys.webstore.profile.delete_confirm.tr(context: context),
      actionText: LocaleKeys.webstore.profile.delete_button.tr(context: context),
      onActionPressed: () {
        ref.read(webStoreAuthViewModelProvider.notifier).deleteAccount();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(webStoreAuthViewModelProvider);
    final isLoading = state is WebStoreAuthLoading;
    final branchState = ref.watch(branchVmProvider);

    ref.listen<WebStoreAuthState>(webStoreAuthViewModelProvider, (prev, next) {
      if (next is WebStoreAuthSuccess) {
        setState(() => _populateFields(next.authResponse.user));
      } else if (next is WebStoreOtpVerified) {
        AppSnackBar.showSuccess(context, next.message);
        setState(() => isEditing = false);
      } else if (next is WebStoreAuthError) {
        AppSnackBar.showError(context, next.message);
      } else if (next is WebStoreAuthIdle && prev is WebStoreAuthLoading) {
        AppNavigator.replace(context, AppRouteNames.webstoreMain);
      }
    });

    final hasAddress = addressController.text.isNotEmpty;
    final hasBranch = _selectedBranchId != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        titleText: LocaleKeys.webstore.profile.title.tr(context: context),
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () {
              if (isEditing && state is WebStoreAuthSuccess) {
                setState(() => _populateFields(state.authResponse.user));
              }
              setState(() => isEditing = !isEditing);
            },
            icon: Icon(
              isEditing ? Icons.close_rounded : Icons.edit_note_rounded,
              color: isEditing ? Colors.red : AppColors.primaryOrange,
              size: 28.sp,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (state is WebStoreAuthSuccess || state is WebStoreOtpVerified || (state is WebStoreAuthLoading && nameController.text.isNotEmpty))
            SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  AppAnimation.fadeInDown(
                    child: Column(
                      children: [
                        ProfileHeader(
                          name: nameController.text,
                          email: emailController.text,
                          isEditing: isEditing,
                        ),
                        if (state is WebStoreAuthSuccess)
                          ProfilePointsCard(points: state.authResponse.user.points),
                      ],
                    ),
                  ),
                  
                  32.verticalSpace,

                  // Editable Information Section
                  ProfileInfoSection(
                    title: LocaleKeys.webstore.profile.personal_info.tr(context: context),
                    children: [
                      ProfileDataField(
                        label: LocaleKeys.webstore.profile.full_name.tr(context: context),
                        controller: nameController,
                        icon: Icons.person_outline,
                        isEditing: isEditing,
                      ),
                      ProfileDataField(
                        label: LocaleKeys.webstore.profile.email_address.tr(context: context),
                        controller: emailController,
                        icon: Icons.email_outlined,
                        isEditing: isEditing,
                      ),
                      ProfileDataField(
                        label: LocaleKeys.webstore.profile.phone_number.tr(context: context),
                        controller: phoneController,
                        icon: Icons.phone_outlined,
                        isEditing: isEditing,
                        isLast: !hasBranch && !hasAddress,
                      ),
                    ],
                  ),
                  
                  20.verticalSpace,

                  // Display-Only Section (Branch and Address)
                  if (hasBranch || hasAddress)
                    ProfileInfoSection(
                      title: LocaleKeys.webstore.profile.store_location.tr(context: context),
                      children: [
                        if (hasBranch) 
                           ProfileDataField(
                            label: LocaleKeys.webstore.profile.your_branch.tr(context: context),
                            controller: TextEditingController(
                              text: (branchState is BranchLoaded) 
                                ? (branchState.branches.any((b) => b.id == _selectedBranchId)
                                    ? branchState.branches.firstWhere((b) => b.id == _selectedBranchId).name
                                    : 'Branch ID: $_selectedBranchId')
                                : '...',
                            ),
                            icon: Icons.storefront_outlined,
                            isEditing: false, // Always Read-only
                            isLast: !hasAddress,
                          ),

                        if (hasAddress)
                          ProfileDataField(
                            label: LocaleKeys.webstore.profile.home_address.tr(context: context),
                            controller: addressController,
                            icon: Icons.location_on_outlined,
                            isEditing: false, // Always Read-only
                            isLast: true,
                          ),
                      ],
                    ),
                  
                  40.verticalSpace,

                  ProfileActionButtons(
                    isEditing: isEditing,
                    isLoading: isLoading,
                    onSave: _onSave,
                    onDelete: _onDeleteAccount,
                  ),
                ],
              ),
            ),
          
          if (isLoading && nameController.text.isEmpty)
            const Center(child: CircularProgressIndicator()),

          if (state is WebStoreAuthError && nameController.text.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  TextButton(
                    onPressed: () => ref.read(webStoreAuthViewModelProvider.notifier).getProfile(),
                    child: Text(LocaleKeys.common.retry.tr(context: context)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
