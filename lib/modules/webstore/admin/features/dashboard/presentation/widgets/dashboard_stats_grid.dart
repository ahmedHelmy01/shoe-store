import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/core/constants/app_constants.dart';
import '../../data/models/admin_statistics_model.dart';
import 'stat_card.dart';

class DashboardStatsGrid extends StatelessWidget {
  final AdminStatisticsModel stats;
  final bool isMobile;
  final double width;

  const DashboardStatsGrid({
    super.key,
    required this.stats,
    required this.isMobile,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AppAnimation.fadeInUp(
      delay: const Duration(milliseconds: 100),
      child: isMobile 
        ? Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildStat('Today Revenue', '${stats.todayRevenue.toStringAsFixed(0)} ${AppConstants.currency}', Icons.auto_graph_rounded, AppColors.primary, (width - 60) / 2),
              _buildStat('Today Orders', stats.todayOrders.toString(), Icons.shopping_bag_outlined, AppColors.secondary, (width - 60) / 2),
              _buildStat('Total Revenue', '${stats.totalRevenue.toStringAsFixed(0)} ${AppConstants.currency}', Icons.account_balance_wallet_rounded, AppColors.success, (width - 60) / 2),
              _buildStat('Total Orders', stats.totalOrders.toString(), Icons.receipt_long_rounded, AppColors.warning, (width - 60) / 2),
              _buildStat('Total Customers', stats.totalCustomers.toString(), Icons.people_outline_rounded, AppColors.info, (width - 60) / 2),
            ],
          )
        : Row(
            children: [
              _buildExpandedStat('Today Revenue', '${stats.todayRevenue.toStringAsFixed(0)} ${AppConstants.currency}', Icons.auto_graph_rounded, AppColors.primary),
              const SizedBox(width: 12),
              _buildExpandedStat('Today Orders', stats.todayOrders.toString(), Icons.shopping_bag_outlined, AppColors.secondary),
              const SizedBox(width: 12),
              _buildExpandedStat('Total Revenue', '${stats.totalRevenue.toStringAsFixed(0)} ${AppConstants.currency}', Icons.account_balance_wallet_rounded, AppColors.success),
              const SizedBox(width: 12),
              _buildExpandedStat('Total Orders', stats.totalOrders.toString(), Icons.receipt_long_rounded, AppColors.warning),
              const SizedBox(width: 12),
              _buildExpandedStat('Total Customers', stats.totalCustomers.toString(), Icons.people_outline_rounded, AppColors.info),
            ],
          ),
    );
  }

  Widget _buildExpandedStat(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: _buildStat(title, value, icon, color, null),
    );
  }

  Widget _buildStat(String title, String value, IconData icon, Color color, double? width) {
    return SizedBox(
      width: width,
      child: StatCard(
        title: title,
        value: value,
        deltaPercent: 0,
        positive: true,
        icon: icon,
      ),
    );
  }
}
