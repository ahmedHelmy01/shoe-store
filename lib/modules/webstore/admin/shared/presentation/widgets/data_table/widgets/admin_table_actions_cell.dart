import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_action_icon_button.dart';
import 'package:erp/core/common_widget/app_dialog/app_dialog.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/data_table/widgets/admin_table_models.dart';
import 'package:flutter/material.dart';

class AdminTableActionsCell<T> extends StatelessWidget {
  final T row;
  final void Function(T row)? onView;
  final void Function(T row)? onEdit;
  final void Function(T row)? onDelete;
  final bool confirmBeforeDelete;
  final String? deleteTitle;
   final String Function(T row)? deleteMessageBuilder;
  final MainAxisAlignment alignment;
  final List<AdminTableCustomAction<T>>? customActions;
  final bool showView;

  const AdminTableActionsCell({
    super.key,
    required this.row,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.confirmBeforeDelete = true,
    this.deleteTitle,
    this.deleteMessageBuilder,
    this.alignment = MainAxisAlignment.start,
    this.customActions,
    this.showView = true,
  });

  void _handleDelete(BuildContext context) {
    if (onDelete == null) return;

    if (!confirmBeforeDelete) {
      onDelete!(row);
      return;
    }

    final message =
        deleteMessageBuilder?.call(row) ??
        'Are you sure you want to delete this item? This action cannot be undone.';

    AppDialog.show(
      context,
      title: deleteTitle ?? 'Confirm Delete',
      message: message,
      cancelText: 'Cancel',
      confirmText: 'Delete',
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () {
        Navigator.of(context).pop();
        onDelete!(row);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewAction = onView ?? onEdit;

    return Row(
      mainAxisAlignment: alignment,
      children: [
        if (showView)
          AdminActionIconButton(
            type: AdminActionIconType.view,
            onPressed: viewAction == null ? null : () => viewAction(row),
          ),
        if (onEdit != null)
          AdminActionIconButton(
            type: AdminActionIconType.edit,
            onPressed: () => onEdit!(row),
          ),
        if (onDelete != null)
          AdminActionIconButton(
            type: AdminActionIconType.delete,
            onPressed: () => _handleDelete(context),
          ),
        if (customActions != null)
          ...customActions!.map((action) => IconButton(
                onPressed: () => action.onPressed(row),
                icon: Icon(action.icon, size: 18, color: action.color),
                tooltip: action.tooltip,
              )),
      ],
    );
  }
}
