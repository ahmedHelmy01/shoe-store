import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/admin_data_table.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_status_badge.dart';
import 'package:erp/modules/webstore/admin/features/dashboard/presentation/widgets/glass_panel.dart';
import '../../data/models/client_report_models.dart';

class TopSpendersTable extends StatelessWidget {
  const TopSpendersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: GlassPanel(
        title: 'Top Spenders',
        child: AdminDataTable<TopSpenderRow>(
          exportBaseName: 'top_spenders',
          idOf: (r) => r.name,
          rows: _buildFakeTopSpenders(),
          cardBuilder: (context, r) => _TopSpenderCard(spender: r),
          columns: [
            AdminColumn(
              title: 'Client Name',
              width: 250,
              cell: (context, r) => Text(
                r.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              sortable: true,
              sortValue: (r) => r.name,
            ),
            AdminColumn(
              title: 'Total Orders',
              width: 150,
              cell: (context, r) => Text(r.orders.toString()),
              sortable: true,
              sortValue: (r) => r.orders,
            ),
            AdminColumn(
              title: 'Total Spent',
              width: 200,
              cell: (context, r) => Text('${r.spent} ${AppConstants.currency}'),
              sortable: true,
              sortValue: (r) => r.spent,
            ),
            AdminColumn(
              title: 'Status',
              width: 150,
              cell: (context, r) => AdminStatusBadge(
                isActive: r.isActive,
                activeLabel: 'Active',
                inactiveLabel: 'Inactive',
              ),
            ),
            AdminColumn(
              title: 'Last Order',
              width: 200,
              cell: (context, r) => Text(r.lastOrder),
              sortable: true,
              sortValue: (r) => r.lastOrder,
            ),
          ],
        ),
      ),
    );
  }

  List<TopSpenderRow> _buildFakeTopSpenders() {
    return [
      TopSpenderRow('Ahmed Mohamed', 45, 15400, true, '2024-04-28'),
      TopSpenderRow('Sarah Jenkins', 38, 12850, true, '2024-04-27'),
      TopSpenderRow('Khalid Al-Sayed', 32, 11200, false, '2024-03-15'),
      TopSpenderRow('John Doe', 28, 9500, true, '2024-04-25'),
      TopSpenderRow('Maria Garcia', 25, 8400, true, '2024-04-20'),
    ];
  }
}

class _TopSpenderCard extends StatelessWidget {
  final TopSpenderRow spender;
  const _TopSpenderCard({required this.spender});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  spender.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              AdminStatusBadge(isActive: spender.isActive),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'Total Orders',
            spender.orders.toString(),
            Icons.shopping_bag_outlined,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            'Total Spent',
            '${spender.spent} ${AppConstants.currency}',
            Icons.payments_outlined,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            'Last Order',
            spender.lastOrder,
            Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.hintColor),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
      ],
    );
  }
}
