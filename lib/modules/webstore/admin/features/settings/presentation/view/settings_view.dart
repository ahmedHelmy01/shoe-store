import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_image_picker.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
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
  String? _logoPath;
  String? _logoDarkPath;
  final _shippingCtrl = TextEditingController();
  final _addressArCtrl = TextEditingController();
  final _addressEnCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _facebookCtrl = TextEditingController();
  final _twitterCtrl = TextEditingController();
  final _instagramCtrl = TextEditingController();
  final _telegramCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController();

  @override
  void dispose() {
    _shippingCtrl.dispose();
    _addressArCtrl.dispose();
    _addressEnCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _facebookCtrl.dispose();
    _twitterCtrl.dispose();
    _instagramCtrl.dispose();
    _telegramCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  StoreSettingsModel _collectForm() {
    return StoreSettingsModel(
      logo: _logoPath,
      logoDark: _logoDarkPath,
      shippingValue: _shippingCtrl.text.trim(),
      addressAr: _addressArCtrl.text.trim(),
      addressEn: _addressEnCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      facebook: _facebookCtrl.text.trim(),
      twitter: _twitterCtrl.text.trim(),
      instagram: _instagramCtrl.text.trim(),
      telegram: _telegramCtrl.text.trim(),
      pointsEgpRate: double.tryParse(_pointsCtrl.text.trim()),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(adminSettingsProvider.notifier).updateSettings(_collectForm());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminSettingsProvider);
    final notifier = ref.read(adminSettingsProvider.notifier);
    final theme = Theme.of(context);

    ref.listen(adminSettingsProvider, (previous, next) {
      if (next.isSuccess) {
        _showStatusDialog(AdminLocalizations.translate(context, 'changes saved!'), AdminLocalizations.translate(context, 'your store settings have been updated successfully.'), false);
        notifier.clearStates();
      } else if (next.error != null && !next.isSaving) {
        _showStatusDialog(AdminLocalizations.translate(context, 'update failed'), next.error!, true);
        notifier.clearStates();
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, state.isSaving),
            const SizedBox(height: 32),
            _buildBrandSection(),
            const SizedBox(height: 24),
            _buildContactSection(),
            const SizedBox(height: 24),
            _buildSocialSection(),
            const SizedBox(height: 24),
            _buildNotesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isSaving) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: AppColors.textColor)),
                  const SizedBox(height: 4),
                  Text(widget.subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                ],
              ),
            ),
            SizedBox(
              width: 180,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : _save,
                icon: isSaving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_rounded),
                label: Text(isSaving ? AdminLocalizations.translate(context, 'saving...') : AdminLocalizations.translate(context, 'save changes')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      ],
    );
  }

  Widget _buildBrandSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.store_rounded, AdminLocalizations.translate(context, 'brand identity')),
          const SizedBox(height: 24),
          AdminImagePicker(
            label: AdminLocalizations.translate(context, 'logo'),
            uploadFolder: 'logos',
            onPathSelected: (path) => setState(() => _logoPath = path),
            onImageSelected: (_) {},
          ),
          const SizedBox(height: 16),
          AdminImagePicker(
            label: AdminLocalizations.translate(context, 'logo (dark)'),
            uploadFolder: 'logos',
            onPathSelected: (path) => setState(() => _logoDarkPath = path),
            onImageSelected: (_) {},
          ),
          const SizedBox(height: 16),
          AppTextField(controller: _addressArCtrl, label: AdminLocalizations.translate(context, 'address (arabic)'), hint: AdminLocalizations.translate(context, 'store address in arabic'), maxLines: 2),
          const SizedBox(height: 16),
          AppTextField(controller: _addressEnCtrl, label: AdminLocalizations.translate(context, 'address (english)'), hint: AdminLocalizations.translate(context, 'store address in english'), maxLines: 2),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.phone_android_rounded, AdminLocalizations.translate(context, 'contact info')),
          const SizedBox(height: 24),
          AppTextField(controller: _mobileCtrl, label: AdminLocalizations.translate(context, 'mobile'), hint: AdminLocalizations.translate(context, 'e.g. 96512345678'), keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          AppTextField(controller: _emailCtrl, label: AdminLocalizations.translate(context, 'email'), hint: AdminLocalizations.translate(context, 'e.g. info@store.com'), keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          AppTextField(controller: _shippingCtrl, label: AdminLocalizations.translate(context, 'shipping value'), hint: AdminLocalizations.translate(context, 'e.g. 2.500'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
          const SizedBox(height: 16),
          AppTextField(controller: _pointsCtrl, label: AdminLocalizations.translate(context, 'points egp rate'), hint: AdminLocalizations.translate(context, 'e.g. 1.0'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
        ],
      ),
    );
  }

  Widget _buildSocialSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.share_rounded, AdminLocalizations.translate(context, 'social media')),
          const SizedBox(height: 24),
          AppTextField(controller: _facebookCtrl, label: 'Facebook', hint: AdminLocalizations.translate(context, 'url or username')),
          const SizedBox(height: 16),
          AppTextField(controller: _twitterCtrl, label: 'Twitter', hint: AdminLocalizations.translate(context, 'url or username')),
          const SizedBox(height: 16),
          AppTextField(controller: _instagramCtrl, label: 'Instagram', hint: AdminLocalizations.translate(context, 'url or username')),
          const SizedBox(height: 16),
          AppTextField(controller: _telegramCtrl, label: 'Telegram', hint: AdminLocalizations.translate(context, 'url or username')),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.info_outline_rounded, AdminLocalizations.translate(context, 'notes')),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AdminLocalizations.translate(context, 'these settings will affect the storefront checkout process and contact information immediately after saving.'),
                    style: TextStyle(color: AppColors.primary.withValues(alpha: 0.8), fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(String title, String message, bool isError) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
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
              Text(title, style: const TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.black.withValues(alpha: 0.5), fontSize: 14, height: 1.5)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isError ? AppColors.error : AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(isError ? AdminLocalizations.translate(context, 'try again') : AdminLocalizations.translate(context, 'done'), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
