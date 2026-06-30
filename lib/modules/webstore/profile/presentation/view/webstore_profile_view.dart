import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:erp/core/common_widget/app_bar/common_app_bar.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/common_widget/app_snack_bar/app_snack_bar.dart';
import 'package:erp/core/common_widget/app_dialog/app_status_dialog.dart';
import 'package:erp/core/common_widget/app_error_widget/app_error_widget.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/home_view_models.dart';
import 'package:erp/modules/webstore/profile/presentation/state/profile_state.dart';
import 'package:erp/modules/webstore/profile/presentation/view_model/profile_providers.dart';
import 'package:erp/core/common_widget/app_bottom_sheet/branch_selection_sheet.dart';
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
  final branchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final state = ref.read(profileViewModelProvider);
      if (state is ProfileLoaded) {
        setState(() => _populateFields(state.user));
      } else {
        ref.read(profileViewModelProvider.notifier).getProfile();
      }
    });
  }

  void _populateFields(WebStoreUser user) {
    nameController.text = user.name;
    emailController.text = user.email ?? '';
    phoneController.text = user.mobile ?? '';
    addressController.text = user.address ?? '';
    _selectedBranchId = user.branchId;
    _originalBranchId = user.branchId;
  }

  int? _selectedBranchId;
  int? _originalBranchId;
  String? _selectedBranchName;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    branchController.dispose();
    super.dispose();
  }

  void _onSave() {
    ref.read(profileViewModelProvider.notifier).updateProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      mobile: phoneController.text.trim(),
      branchId: (_selectedBranchId != _originalBranchId) ? _selectedBranchId : null,
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
        ref.read(profileViewModelProvider.notifier).deleteAccount();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(profileViewModelProvider);
    final isLoading = state is ProfileLoading;
    final branchState = ref.watch(branchVmProvider);

    ref.listen<ProfileState>(profileViewModelProvider, (prev, next) {
      if (next is ProfileLoaded) {
        setState(() => _populateFields(next.user));
      } else if (next is ProfileUpdateSuccess) {
        AppStatusDialog.showSuccess(
          context,
          title: LocaleKeys.webstore.profile.update_success.tr(context: context),
          message: LocaleKeys.webstore.profile.update_success.tr(context: context),
        );
        setState(() {
          isEditing = false;
          _populateFields(next.user);
        });
      } else if (next is ProfileError) {
        if (nameController.text.isNotEmpty) {
          AppSnackBar.showError(context, next.message);
        } else {
          AppStatusDialog.showError(
            context,
            title: LocaleKeys.common.error.tr(context: context),
            message: next.message,
          );
        }
      } else if (next is ProfileDeleted) {
        AppNavigator.replace(context, AppRouteNames.webstoreMain);
      }
    });

    final hasAddress = addressController.text.isNotEmpty;
    final hasBranch = _selectedBranchId != null;
    final hasUserData = state is ProfileLoaded || state is ProfileUpdateSuccess || (state is ProfileLoading && nameController.text.isNotEmpty) || (state is ProfileError && nameController.text.isNotEmpty);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CommonAppBar(
        titleText: LocaleKeys.webstore.profile.title.tr(context: context),
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () {
              if (isEditing) {
                if (state is ProfileLoaded) {
                  setState(() => _populateFields(state.user));
                } else if (state is ProfileUpdateSuccess) {
                  setState(() => _populateFields(state.user));
                }
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
          if (hasUserData)
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
                        if (state is ProfileLoaded)
                          ProfilePointsCard(points: state.user.points),
                        if (state is ProfileUpdateSuccess)
                          ProfilePointsCard(points: state.user.points),
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
                          Builder(
                            builder: (_) {
                              final userModel = state is ProfileLoaded
                                  ? state.user
                                  : state is ProfileUpdateSuccess
                                      ? state.user
                                      : null;
                              branchController.text = _selectedBranchName ??
                                  userModel?.branchName ??
                                  ((branchState is BranchLoaded)
                                      ? (branchState.branches.any((b) => b.id == _selectedBranchId)
                                          ? branchState.branches.firstWhere((b) => b.id == _selectedBranchId).name
                                          : 'Branch ID: $_selectedBranchId')
                                      : '...');
                              return ProfileDataField(
                                label: LocaleKeys.webstore.profile.your_branch.tr(context: context),
                                controller: branchController,
                                icon: Icons.storefront_outlined,
                                isEditing: isEditing,
                                isLast: !hasAddress,
                                onTap: () async {
                                  final locale = context.locale.languageCode;
                                  final selected = await showModalBottomSheet<int>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => const BranchSelectionSheet(),
                                  );
                                  if (selected != null && mounted) {
                                    final bs = ref.read(branchVmProvider);
                                    String name;
                                    if (bs is BranchLoaded) {
                                      final b = bs.branches.firstWhere((b) => b.id == selected);
                                      name = locale == 'ar' ? b.nameAr : b.name;
                                    } else {
                                      name = 'Branch ID: $selected';
                                    }
                                    setState(() {
                                      _selectedBranchId = selected;
                                      _selectedBranchName = name;
                                      branchController.text = name;
                                    });
                                  }
                                },
                              );
                            },
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

          if (state is ProfileError && nameController.text.isEmpty)
            Center(
              child: AppErrorWidget(
                errorMessage: state.message,
                onRetry: () => ref.read(profileViewModelProvider.notifier).getProfile(),
              ),
            ),
        ],
      ),
    );
  }
}
