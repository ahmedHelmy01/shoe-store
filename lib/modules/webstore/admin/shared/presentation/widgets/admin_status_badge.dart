import 'package:flutter/material.dart';
import 'package:erp/modules/webstore/admin/shared/utils/admin_localizations.dart';

class AdminStatusBadge extends StatelessWidget {
  final bool isActive;
  final String? label;
  final String? activeLabel;
  final String? inactiveLabel;
  final Color? activeColor;
  final Color? inactiveColor;

  const AdminStatusBadge({
    super.key,
    required this.isActive,
    this.label,
    this.activeLabel = 'Active',
    this.inactiveLabel = 'Inactive',
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive ? activeColor! : inactiveColor!;
    
    final translatedActive = activeLabel == 'Active' 
        ? AdminLocalizations.translate(context, 'active') 
        : AdminLocalizations.translate(context, activeLabel!);
        
    final translatedInactive = inactiveLabel == 'Inactive' 
        ? AdminLocalizations.translate(context, 'inactive') 
        : AdminLocalizations.translate(context, inactiveLabel!);
        
    final text = label != null 
        ? AdminLocalizations.translate(context, label!) 
        : (isActive ? translatedActive : translatedInactive);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
