import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/data/models/admin_customer_points_model.dart';
import 'package:erp/modules/webstore/admin/features/loyalty/presentation/view_model/loyalty_admin_providers.dart';
import 'customer_points_adjust_dialog.dart';

class CustomerPointsView extends ConsumerStatefulWidget {
  final dynamic customerId;
  final String customerName;

  const CustomerPointsView({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  ConsumerState<CustomerPointsView> createState() => _CustomerPointsViewState();
}

class _CustomerPointsViewState extends ConsumerState<CustomerPointsView> {
  @override
  Widget build(BuildContext context) {
    final pointsAsync = ref.watch(customerPointsProvider(widget.customerId));
    final adjustState = ref.watch(adjustCustomerPointsProvider);
    final isAdjusting = adjustState.status == SaveStatus.saving;
    final theme = Theme.of(context);

    ref.listen<UpdateLoyaltySettingsState>(adjustCustomerPointsProvider, (prev, next) {
      if (next.status == SaveStatus.success) {
        ref.invalidate(customerPointsProvider(widget.customerId));
        ref.read(adjustCustomerPointsProvider.notifier).reset();
        _showStatusDialog(
          AdminLocalizations.translate(context, 'Points Adjusted'),
          AdminLocalizations.translate(context, 'Customer points have been updated successfully.'),
          false,
        );
      } else if (next.status == SaveStatus.error) {
        _showStatusDialog(
          AdminLocalizations.translate(context, 'Adjustment Failed'),
          next.error ?? '',
          true,
        );
        ref.read(adjustCustomerPointsProvider.notifier).reset();
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 24),
          pointsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _buildError(e),
            data: (data) => _buildContent(theme, data, isAdjusting),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.customerName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AdminLocalizations.translate(context, 'Customer Points & Transactions'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme, AdminCustomerPointsModel data, bool isAdjusting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryCards(theme, data),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: isAdjusting ? null : () => _openAdjustDialog(data),
                  icon: isAdjusting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.swap_horiz_rounded),
                  label: Text(isAdjusting ? 'Adjusting...' : 'Adjust Points'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionTitle(Icons.history_rounded, AdminLocalizations.translate(context, 'Transaction History')),
        const SizedBox(height: 16),
        if (data.transactions.isEmpty)
          _buildCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  AdminLocalizations.translate(context, 'No transactions found.'),
                  style: TextStyle(color: AppColors.textHint, fontSize: 14),
                ),
              ),
            ),
          )
        else
          ...data.transactions.map((tx) => _buildTransactionRow(theme, tx)),
      ],
    );
  }

  Widget _buildSummaryCards(ThemeData theme, AdminCustomerPointsModel data) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(Icons.dashboard_rounded, AdminLocalizations.translate(context, 'Summary')),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildStatCard('Balance', '${data.balance}', AppColors.primary, Icons.account_balance_wallet_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Total Earned', '${data.totalEarned}', AppColors.success, Icons.arrow_upward_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Total Used', '${data.totalUsed}', AppColors.error, Icons.arrow_downward_rounded)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Expired', '${data.totalExpired}', AppColors.warning, Icons.timer_off_rounded)),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Nearest Expiry',
                  data.nearestExpiryDate ?? 'N/A',
                  AppColors.info,
                  Icons.event_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Monetary Value',
                  data.monetaryValue != null ? '${data.monetaryValue!.toStringAsFixed(2)} EGP' : 'N/A',
                  AppColors.accent,
                  Icons.attach_money_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(ThemeData theme, AdminPointTransaction tx) {
    final isEarned = tx.type == 'earned' || tx.type == 'added' || tx.type == 'awarded' || tx.points > 0;
    final color = isEarned ? AppColors.success : AppColors.error;
    return _buildCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(isEarned ? Icons.add_card_rounded : Icons.remove_circle_outline_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.reason ?? tx.type,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  tx.createdAt,
                  style: TextStyle(color: AppColors.textHint, fontSize: 12),
                ),
                if (tx.adjustedBy != null) ...[
                  const SizedBox(height: 2),
                  Text('by ${tx.adjustedBy}', style: TextStyle(color: AppColors.textHint, fontSize: 11)),
                ],
              ],
            ),
          ),
          Text(
            '${isEarned ? '+' : '-'}${tx.points}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(Object error) {
    return _buildCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.error.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 12),
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

  Future<void> _openAdjustDialog(AdminCustomerPointsModel data) async {
    final result = await showDialog<CustomerPointsAdjustResult>(
      context: context,
      builder: (_) => CustomerPointsAdjustDialog(
        customerId: widget.customerId,
        customerName: widget.customerName,
      ),
    );
    if (result == null || !mounted) return;
    ref.read(adjustCustomerPointsProvider.notifier).adjust(
      widget.customerId,
      result.points,
      result.reason,
      result.isDeduct,
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
