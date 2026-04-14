import 'package:erp/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hugeicons/styles/stroke_rounded.dart';

enum AdminActionIconType { view, edit, delete }

class AdminActionIconButton extends StatelessWidget {
  final AdminActionIconType type;
  final VoidCallback? onPressed;
  final String? tooltip;

  const AdminActionIconButton({
    super.key,
    required this.type,
    required this.onPressed,
    this.tooltip,
  });

  static List<List<dynamic>> iconOf(AdminActionIconType type) {
    return switch (type) {
      AdminActionIconType.view => HugeIconsStrokeRounded.view,
      AdminActionIconType.edit => HugeIconsStrokeRounded.pencilEdit02,
      AdminActionIconType.delete => HugeIconsStrokeRounded.delete02,
    };
  }

  static Color colorOf(AdminActionIconType type) {
    return switch (type) {
      AdminActionIconType.view => const Color(0xFF3B82F6),
      AdminActionIconType.edit => AppColors.primaryOrange,
      AdminActionIconType.delete => AppColors.error,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = colorOf(type);
    final label = tooltip ??
        switch (type) {
          AdminActionIconType.view => 'View',
          AdminActionIconType.edit => 'Edit',
          AdminActionIconType.delete => 'Delete',
        };

    return Tooltip(
      message: label,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.18),
              color.withValues(alpha: 0.08),
            ],
          ),
          border: Border.all(color: color.withValues(alpha: 0.28)),
        ),
        child: IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: onPressed,
          icon: HugeIcon(
            icon: iconOf(type),
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}
