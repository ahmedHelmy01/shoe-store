import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'admin_action_icon_button.dart';

/// A standardized popup menu for mobile admin cards.
///
/// Provides consistent "Details", "Edit", and "Delete" actions using
/// HugeIcons with the same color scheme as [AdminActionIconButton].
class AdminCardPopupMenu extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// Label for the view action (defaults to 'Details').
  final String viewLabel;

  /// Label for the edit action (defaults to 'Edit').
  final String editLabel;

  /// Label for the delete action (defaults to 'Delete').
  final String deleteLabel;

  const AdminCardPopupMenu({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.viewLabel = 'Details',
    this.editLabel = 'Edit',
    this.deleteLabel = 'Delete',
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        if (onView != null)
          _buildItem(
            onTap: onView!,
            type: AdminActionIconType.view,
            label: viewLabel,
          ),
        if (onEdit != null)
          _buildItem(
            onTap: onEdit!,
            type: AdminActionIconType.edit,
            label: editLabel,
          ),
        if (onDelete != null)
          _buildItem(
            onTap: onDelete!,
            type: AdminActionIconType.delete,
            label: deleteLabel,
          ),
      ],
    );
  }

  PopupMenuItem _buildItem({
    required VoidCallback onTap,
    required AdminActionIconType type,
    required String label,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          HugeIcon(
            icon: AdminActionIconButton.iconOf(type),
            color: AdminActionIconButton.colorOf(type),
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
