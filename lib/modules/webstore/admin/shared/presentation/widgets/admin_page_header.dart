import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

class AdminPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onRefresh; // Keep for internal logic if needed, but remove from UI
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final VoidCallback? onPrimaryAction;

  const AdminPageHeader({
    super.key,
    required this.title,
    this.onRefresh,
    this.primaryActionLabel,
    this.primaryActionIcon,
    this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900, 
              letterSpacing: -1,
            ),
          ),
          if (onPrimaryAction != null) ...[
            const SizedBox(height: 16),
            _buildPrimaryButton(context, isFullWidth: true),
          ],
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900, 
              letterSpacing: -0.5,
            ),
          ),
        ),
        if (onPrimaryAction != null) ...[
          _buildPrimaryButton(context),
        ],
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context, {bool isFullWidth = false}) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: FilledButton.icon(
        onPressed: onPrimaryAction,
        icon: Icon(primaryActionIcon ?? Icons.add_rounded, size: 20),
        label: Text(
          primaryActionLabel ?? 'Add New',
          style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.2),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ),
    );
  }
}
