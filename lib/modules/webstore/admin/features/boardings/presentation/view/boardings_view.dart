import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import '../view_model/boardings_state.dart';
import '../view_model/boardings_view_model.dart';
import '../widgets/boardings_table.dart';
import '../widgets/boardings_mobile_list.dart';

class BoardingsView extends ConsumerWidget {
  const BoardingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final state = ref.watch(boardingsVmProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Boardings',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                tooltip: 'Refresh',
                onPressed: () => ref.read(boardingsVmProvider.notifier).refresh(),
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

  Widget _buildBody(BuildContext context, BoardingsState state, bool isDark, bool isWide, WidgetRef ref) {
    return switch (state) {
      BoardingsLoading() => const Center(child: CircularProgressIndicator()),
      BoardingsError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(boardingsVmProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      BoardingsData(:final items) => AppAnimation.fadeInUp(
          duration: const Duration(milliseconds: 420),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
              ),
            ),
            child: isWide ? BoardingsTable(items: items) : BoardingsMobileList(items: items),
          ),
        ),
    };
  }
}
