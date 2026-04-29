import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import '../view_model/settings_view_model.dart';
import '../../data/models/store_settings_model.dart';

class SettingsView extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const SettingsView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _logoController = TextEditingController();
  final _mobileController = TextEditingController();
  final _shippingController = TextEditingController();

  @override
  void dispose() {
    _logoController.dispose();
    _mobileController.dispose();
    _shippingController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final settings = StoreSettingsModel(
        logo: _logoController.text,
        mobile: _mobileController.text,
        shippingValue: _shippingController.text,
      );
      ref.read(adminSettingsProvider.notifier).updateSettings(settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminSettingsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Listen for success/error
    ref.listen(adminSettingsProvider, (previous, next) {
      if (next.isSuccess) {
        _showStatusDialog(
          context,
          title: 'Changes Saved!',
          message: 'Your store settings have been updated successfully.',
          isError: false,
        );
      } else if (next.error != null) {
        _showStatusDialog(
          context,
          title: 'Update Failed',
          message: next.error!,
          isError: true,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(state.isSaving),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      SizedBox(
                        width: isWide
                            ? (constraints.maxWidth - 24) / 2
                            : constraints.maxWidth,
                        child: _buildGeneralSettings(theme, isDark),
                      ),
                      SizedBox(
                        width: isWide
                            ? (constraints.maxWidth - 24) / 2
                            : constraints.maxWidth,
                        child: _buildLogisticsSettings(theme, isDark),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isSaving) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                widget.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: isSaving ? null : _save,
          icon: isSaving
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Icon(Icons.save_rounded),
          label: Text(isSaving ? 'Saving...' : 'Save Changes'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralSettings(ThemeData theme, bool isDark) {
    return AppAnimation.fadeInLeft(
      child: _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(theme, Icons.store_rounded, 'Brand Identity'),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _logoController,
              label: 'Store Logo URL',
              hint: 'e.g., uploads/logo.png',
              icon: Icons.image_outlined,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _mobileController,
              label: 'Support Mobile Number',
              hint: 'e.g., 96512345678',
              icon: Icons.phone_android_rounded,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogisticsSettings(ThemeData theme, bool isDark) {
    return AppAnimation.fadeInRight(
      child: _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              theme,
              Icons.local_shipping_rounded,
              'Logistics & Fees',
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _shippingController,
              label: 'Standard Shipping Fee',
              hint: 'e.g., 2.500',
              icon: Icons.payments_outlined,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'These settings will affect the storefront checkout process immediately after saving.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(ThemeData theme, IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.02),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.05),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showStatusDialog(
    BuildContext context, {
    required String title,
    required String message,
    required bool isError,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (isError ? AppColors.error : AppColors.success).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                  color: isError ? AppColors.error : AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.5),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(adminSettingsProvider.notifier).clearStates();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isError ? AppColors.error : AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    isError ? 'Try Again' : 'Done',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
