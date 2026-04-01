/// ERP System - Empty State Widget
///
/// Reusable empty state placeholder with customizable icon and message.
library;

import 'package:flutter/material.dart';
import 'package:erp/core/constants/app_constants.dart';

class AppEmptyWidget extends StatelessWidget {
  final String? message;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;

  const AppEmptyWidget({
    super.key,
    this.message,
    this.actionText,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_rounded,
              size: 72,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'لا توجد بيانات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded),
                label: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Empty cart variant
  factory AppEmptyWidget.cart({VoidCallback? onAction}) {
    return AppEmptyWidget(
      message: 'سلة المشتريات فارغة',
      icon: Icons.shopping_cart_outlined,
      actionText: 'تصفح المنتجات',
      onAction: onAction,
    );
  }

  /// Empty orders variant
  factory AppEmptyWidget.orders() {
    return const AppEmptyWidget(
      message: 'لا توجد طلبات حتى الآن',
      icon: Icons.receipt_long_outlined,
    );
  }

  /// Empty search variant
  factory AppEmptyWidget.search() {
    return const AppEmptyWidget(
      message: 'لم يتم العثور على نتائج',
      icon: Icons.search_off_rounded,
    );
  }
}
