import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_widget/app_animation/app_animation.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_page_header.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_state_widget.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_card_popup_menu.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';
import '../view_model/users_view_model.dart';
import '../../data/models/user_row.dart';
import '../widgets/users_table.dart';


class UsersView extends ConsumerWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usersVmProvider);
    final notifier = ref.read(usersVmProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title: AdminLocalizations.translate(context, 'users'),
            onRefresh: () => notifier.fetch(),
          ),
          const SizedBox(height: 24),
          Expanded(child: _buildBody(context, state, isDark, notifier)),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AdminCrudState<UserRow> state,
    bool isDark,
    UsersVm notifier,
  ) {
    return switch (state) {
      AdminCrudLoading() => const Center(child: CircularProgressIndicator()),
      AdminCrudError(:final message) => AdminStateWidget(
        message: message,
        onRetry: () => notifier.fetch(),
      ),
      AdminCrudData(:final items) => AppAnimation.fadeInUp(
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F1B2D) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.05,
              ),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: UsersTable(
            items: items,
            onDelete: (item) => notifier.commitDelete(item.id),
            cardBuilder: (context, item) => _UserCard(
              user: item,
              onView: () {
                showDialog(
                  context: context,
                  builder: (_) => UserDetailsDialog(user: item),
                );
              },
              onDelete: () => notifier.commitDelete(item.id),
            ),
          ),
        ),
      ),
    };
  }
}

class _UserCard extends StatelessWidget {
  final UserRow user;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const _UserCard({
    required this.user,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF162231) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _UserAvatar(name: user.name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (user.email != null)
                      Text(
                        user.email!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                        ),
                      ),
                  ],
                ),
              ),
              AdminCardPopupMenu(
                onView: onView,
                onDelete: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoItem(label: AdminLocalizations.translate(context, 'orders'), value: '${user.ordersCount}', color: theme.primaryColor),
              _InfoItem(label: AdminLocalizations.translate(context, 'total spent'), value: '${user.totalSpent.toStringAsFixed(0)} EGP', color: Colors.green),
              _InfoItem(label: AdminLocalizations.translate(context, 'mobile'), value: user.mobile ?? '—'),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String name;
  const _UserAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return CircleAvatar(
      radius: 20,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      child: Text(
        initials,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _InfoItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
