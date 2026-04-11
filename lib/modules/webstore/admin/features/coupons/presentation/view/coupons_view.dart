import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import '../view_model/coupons_state.dart';
import '../view_model/coupons_view_model.dart';
import '../widgets/coupons_table.dart';

class CouponsView extends ConsumerWidget {
  const CouponsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final state = ref.watch(couponsVmProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Coupons',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: () => ref.read(couponsVmProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _buildBody(context, state, isDark, isWide, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CouponsState state, bool isDark, bool isWide, WidgetRef ref) {
    return switch (state) {
      CouponsLoading() => const Center(child: CircularProgressIndicator()),
      CouponsError(:final message) => Center(child: Text(message)),
      CouponsData(:final items) => AppAnimation.fadeInUp(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
              border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
            ),
            child: isWide
                ? CouponsTable(items: items)
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) => ListTile(title: Text(items[i].code)),
                  ),
          ),
        ),
    };
  }
}
