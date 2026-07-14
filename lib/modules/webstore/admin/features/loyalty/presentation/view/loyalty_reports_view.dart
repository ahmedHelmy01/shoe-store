import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import 'reports/balances_report_view.dart';
import 'reports/movement_report_view.dart';
import 'reports/redemptions_report_view.dart';
import 'reports/earned_report_view.dart';
import 'reports/expired_report_view.dart';
import 'reports/top_report_view.dart';
import 'reports/cost_report_view.dart';

class LoyaltyReportsView extends ConsumerStatefulWidget {
  const LoyaltyReportsView({super.key});

  @override
  ConsumerState<LoyaltyReportsView> createState() => _LoyaltyReportsViewState();
}

class _LoyaltyReportsViewState extends ConsumerState<LoyaltyReportsView> {
  int _selectedTab = 0;

  final _tabs = <String>['balances', 'movement', 'redemptions', 'earned', 'expired', 'top', 'cost'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AdminLocalizations.translate(context, 'Loyalty Reports'),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AdminLocalizations.translate(context, 'View loyalty program reports and analytics'),
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: _tabs.asMap().entries.map((entry) {
              final i = entry.key;
              final tab = entry.value;
              final selected = _selectedTab == i;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_tabLabel(tab)),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedTab = i),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: selected ? FontWeight.bold : null,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildReport()),
      ],
    );
  }

  String _tabLabel(String tab) {
    switch (tab) {
      case 'balances': return AdminLocalizations.translate(context, 'Balances');
      case 'movement': return AdminLocalizations.translate(context, 'Movement');
      case 'redemptions': return AdminLocalizations.translate(context, 'Redemptions');
      case 'earned': return AdminLocalizations.translate(context, 'Earned');
      case 'expired': return AdminLocalizations.translate(context, 'Expired');
      case 'top': return AdminLocalizations.translate(context, 'Top Customers');
      case 'cost': return AdminLocalizations.translate(context, 'Cost');
      default: return tab;
    }
  }

  Widget _buildReport() {
    switch (_selectedTab) {
      case 0: return const BalancesReportView();
      case 1: return const MovementReportView();
      case 2: return const RedemptionsReportView();
      case 3: return const EarnedReportView();
      case 4: return const ExpiredReportView();
      case 5: return const TopReportView();
      case 6: return const CostReportView();
      default: return const BalancesReportView();
    }
  }
}
