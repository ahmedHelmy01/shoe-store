import 'package:flutter/material.dart';

typedef AdminIdOf<T> = String Function(T row);
typedef AdminCellText<T> = String Function(T row);

class AdminColumn<T> {
  final String title;
  final double? width;
  final bool sortable;
  final Comparable? Function(T row)? sortValue;
  final String Function(T row)? exportValue;
  final Widget Function(BuildContext context, T row) cell;

  const AdminColumn({
    required this.title,
    required this.cell,
    this.width,
    this.sortable = false,
    this.sortValue,
    this.exportValue,
  });
}

class AdminTableCustomAction<T> {
  final IconData icon;
  final String tooltip;
  final Color? color;
  final void Function(T row) onPressed;

  const AdminTableCustomAction({
    required this.icon,
    required this.tooltip,
    this.color,
    required this.onPressed,
  });
}
