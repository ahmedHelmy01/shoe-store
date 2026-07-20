import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/common_widget/app_text_field/app_text_field.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/models/loyalty_settings_model.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/presentation/view_model/loyalty_admin_providers.dart';

class LoyaltySettingsView extends ConsumerStatefulWidget {
  const LoyaltySettingsView({super.key});

  @override
  ConsumerState<LoyaltySettingsView> createState() => _LoyaltySettingsViewState();
}

class _LoyaltySettingsViewState extends ConsumerState<LoyaltySettingsView> {
  final _formKey = GlobalKey<FormState>();
  bool _enabled = false;
  final _earnRateCtrl = TextEditingController();
  final _pointValueCtrl = TextEditingController();
  String _maxUsageType = 'unlimited';
  final _maxUsageValueCtrl = TextEditingController();
  final _minInvoiceCtrl = TextEditingController();
  final _minPointsCtrl = TextEditingController();
  String _expiryType = 'never';
  final _expiryValueCtrl = TextEditingController();
  List<String> _eligibleTypes = [];
  final _excludedProductsCtrl = TextEditingController();
  final _excludedCategoriesCtrl = TextEditingController();

  bool _initialLoaded = false;

  @override
  void dispose() {
    _earnRateCtrl.dispose();
    _pointValueCtrl.dispose();
    _maxUsageValueCtrl.dispose();
    _minInvoiceCtrl.dispose();
    _minPointsCtrl.dispose();
    _expiryValueCtrl.dispose();
    _excludedProductsCtrl.dispose();
    _excludedCategoriesCtrl.dispose();
    super.dispose();
  }

  LoyaltySettingsModel _collectForm() {
    return LoyaltySettingsModel(
      enabled: _enabled,
      earnRate: double.tryParse(_earnRateCtrl.text.trim()) ?? 0.0,
      pointValue: double.tryParse(_pointValueCtrl.text.trim()) ?? 0.0,
      maxUsageType: _maxUsageType,
      maxUsageValue: double.tryParse(_maxUsageValueCtrl.text.trim()) ?? 0.0,
      minInvoiceAmount: double.tryParse(_minInvoiceCtrl.text.trim()) ?? 0.0,
      minPointsToUse: int.tryParse(_minPointsCtrl.text.trim()) ?? 0,
      expiryType: _expiryType,
      expiryValue: int.tryParse(_expiryValueCtrl.text.trim()) ?? 0,
      eligibleCustomerTypes: _eligibleTypes,
      excludedProductIds: _excludedProductsCtrl.text.trim().isEmpty
          ? const []
          : _excludedProductsCtrl.text.trim().split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList(),
      excludedCategoryIds: _excludedCategoriesCtrl.text.trim().isEmpty
          ? const []
          : _excludedCategoriesCtrl.text.trim().split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList(),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(updateLoyaltySettingsProvider.notifier).updateSettings(_collectForm());
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(loyaltySettingsProvider);
    settingsAsync.whenOrNull(data: (settings) {
      if (!_initialLoaded) {
        _initialLoaded = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _enabled = settings.enabled;
            _earnRateCtrl.text = settings.earnRate.toString();
            _pointValueCtrl.text = settings.pointValue.toString();
            _maxUsageType = settings.maxUsageType;
            _maxUsageValueCtrl.text = settings.maxUsageValue.toString();
            _minInvoiceCtrl.text = settings.minInvoiceAmount.toString();
            _minPointsCtrl.text = settings.minPointsToUse.toString();
            _expiryType = settings.expiryType;
            _expiryValueCtrl.text = settings.expiryValue.toString();
            _eligibleTypes = List.from(settings.eligibleCustomerTypes);
            _excludedProductsCtrl.text = settings.excludedProductIds.join(',');
            _excludedCategoriesCtrl.text = settings.excludedCategoryIds.join(',');
          });
        });
      }
    });
    final saveState = ref.watch(updateLoyaltySettingsProvider);
    final isSaving = saveState.status == SaveStatus.saving;
    final theme = Theme.of(context);

    ref.listen<UpdateLoyaltySettingsState>(updateLoyaltySettingsProvider, (previous, next) {
      if (next.status == SaveStatus.success) {
        _showStatusDialog(
          AdminLocalizations.translate(context, 'changes saved!'),
          AdminLocalizations.translate(context, 'your store settings have been updated successfully.'),
          false,
        );
        ref.read(updateLoyaltySettingsProvider.notifier).reset();
      } else if (next.status == SaveStatus.error) {
        _showStatusDialog(
          AdminLocalizations.translate(context, 'update failed'),
          next.error ?? '',
          true,
        );
        ref.read(updateLoyaltySettingsProvider.notifier).reset();
      }
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: _buildHeader(theme, isSaving),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (settingsAsync is AsyncLoading) ...[
                    const Center(child: CircularProgressIndicator())
                  ] else if (settingsAsync is AsyncError) ...[
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline_rounded, size: 64, color: theme.colorScheme.error),
                          const SizedBox(height: 16),
                          Text(
                            AdminLocalizations.translate(context, 'فشل تحميل الإعدادات'),
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () => ref.invalidate(loyaltySettingsProvider),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(AdminLocalizations.translate(context, 'إعادة المحاولة')),
                          ),
                        ],
                      ),
                    )
                  ] else
                    ..._buildSections(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSections() {
    return [
      _buildGeneralSection(),
      const SizedBox(height: 24),
      _buildUsageRulesSection(),
      const SizedBox(height: 24),
      _buildExpirySection(),
      const SizedBox(height: 24),
      _buildRestrictionsSection(),
    ];
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
                  Text(
                    AdminLocalizations.translate(context, 'Loyalty Program'),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AdminLocalizations.translate(context, 'Manage loyalty points and rewards settings.'),
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                  ),
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

  Widget _buildGeneralSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.tune_rounded, AdminLocalizations.translate(context, 'General Settings')),
          const SizedBox(height: 24),
          SwitchListTile(
            title: Text(AdminLocalizations.translate(context, 'Enable Loyalty Program'), style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(AdminLocalizations.translate(context, 'Allow customers to earn and redeem points.')),
            value: _enabled,
            activeThumbColor: AppColors.primary,
            onChanged: (v) => setState(() => _enabled = v),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _earnRateCtrl,
            label: AdminLocalizations.translate(context, 'Earn Rate'),
            hint: AdminLocalizations.translate(context, 'Points per currency unit'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _pointValueCtrl,
            label: AdminLocalizations.translate(context, 'Point Value'),
            hint: AdminLocalizations.translate(context, 'Monetary value per point'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageRulesSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.rule_rounded, AdminLocalizations.translate(context, 'Usage Rules')),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: _maxUsageType,
            decoration: InputDecoration(
              labelText: AdminLocalizations.translate(context, 'Max Usage Type'),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textSecondary),
              fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor : AppColors.surface,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: const [
              DropdownMenuItem(value: 'unlimited', child: Text('Unlimited')),
              DropdownMenuItem(value: 'fixed', child: Text('Fixed')),
              DropdownMenuItem(value: 'percentage', child: Text('Percentage')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _maxUsageType = v);
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _maxUsageValueCtrl,
            label: AdminLocalizations.translate(context, 'Max Usage Value'),
            hint: AdminLocalizations.translate(context, 'e.g. 100'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _minInvoiceCtrl,
            label: AdminLocalizations.translate(context, 'Min Invoice Amount'),
            hint: AdminLocalizations.translate(context, 'e.g. 50'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _minPointsCtrl,
            label: AdminLocalizations.translate(context, 'Min Points to Use'),
            hint: AdminLocalizations.translate(context, 'e.g. 100'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildExpirySection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.schedule_rounded, AdminLocalizations.translate(context, 'Expiry Settings')),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: _expiryType,
            decoration: InputDecoration(
              labelText: AdminLocalizations.translate(context, 'Expiry Type'),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textSecondary),
              fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).cardColor : AppColors.surface,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: const [
              DropdownMenuItem(value: 'days', child: Text('Days')),
              DropdownMenuItem(value: 'months', child: Text('Months')),
              DropdownMenuItem(value: 'years', child: Text('Years')),
              DropdownMenuItem(value: 'never', child: Text('Never')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _expiryType = v);
            },
          ),
          if (_expiryType != 'never') ...[
            const SizedBox(height: 16),
            AppTextField(
              controller: _expiryValueCtrl,
              label: AdminLocalizations.translate(context, 'Expiry Value'),
              hint: AdminLocalizations.translate(context, 'e.g. 30'),
              keyboardType: TextInputType.number,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRestrictionsSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.lock_rounded, AdminLocalizations.translate(context, 'Restrictions')),
          const SizedBox(height: 24),
          Text(
            AdminLocalizations.translate(context, 'Customer Types'),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: ['regular', 'vip', 'wholesale', 'retail'].map((type) {
              final selected = _eligibleTypes.contains(type);
              return FilterChip(
                label: Text(type[0].toUpperCase() + type.substring(1)),
                selected: selected,
                selectedColor: AppColors.primary.withValues(alpha: 0.15),
                checkmarkColor: AppColors.primary,
                onSelected: (v) {
                  setState(() {
                    if (v) {
                      _eligibleTypes = [..._eligibleTypes, type];
                    } else {
                      _eligibleTypes = _eligibleTypes.where((t) => t != type).toList();
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _excludedProductsCtrl,
            label: AdminLocalizations.translate(context, 'Excluded Product IDs'),
            hint: AdminLocalizations.translate(context, 'Comma-separated IDs'),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _excludedCategoriesCtrl,
            label: AdminLocalizations.translate(context, 'Excluded Category IDs'),
            hint: AdminLocalizations.translate(context, 'Comma-separated IDs'),
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
