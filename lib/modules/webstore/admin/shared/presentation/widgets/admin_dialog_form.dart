import 'dart:ui';
import 'package:flutter/material.dart';

enum AdminDialogSize { small, medium, large, xlarge }

class AdminDialogForm extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final String title;
  final Widget child;
  final Widget? footer;
  final AdminDialogSize size;
  final double? customHeightFactor;
  final double reserveSpace;
  final bool closeOnBackdropTap;

  const AdminDialogForm({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.title,
    required this.child,
    this.footer,
    this.size = AdminDialogSize.medium,
    this.customHeightFactor,
    this.reserveSpace = 28,
    this.closeOnBackdropTap = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 720;

    return Stack(
      children: [
        // Glassmorphism Backdrop
        GestureDetector(
          onTap: closeOnBackdropTap ? onClose : null,
          behavior: HitTestBehavior.opaque,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 280),
            builder: (context, value, _) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5 * value, sigmaY: 5 * value),
              child: Container(
                color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.3 * value),
              ),
            ),
          ),
        ),

        // Centered Dialog Card
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.95, end: 1.0),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: Opacity(opacity: ((value - 0.95) * 20).clamp(0.0, 1.0), child: child),
            ),
            child: GestureDetector(
              onTap: () {},
              child: _buildDialogContent(context, isMobile, theme, isDark),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogContent(BuildContext context, bool isMobile, ThemeData theme, bool isDark) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    double dialogWidth;
    double heightFactor;
    if (isMobile) {
      dialogWidth = screenWidth * 0.92;
      heightFactor = switch (size) {
        AdminDialogSize.small => 0.70,
        AdminDialogSize.medium => 0.82,
        AdminDialogSize.large => 0.88,
        AdminDialogSize.xlarge => 0.92,
      };
    } else {
      dialogWidth = switch (size) {
        AdminDialogSize.small => 560.0,
        AdminDialogSize.medium => 720.0,
        AdminDialogSize.large => 860.0,
        AdminDialogSize.xlarge => 1000.0,
      };
      if (dialogWidth > screenWidth * 0.92) dialogWidth = screenWidth * 0.92;

      heightFactor = switch (size) {
        AdminDialogSize.small => 0.62,
        AdminDialogSize.medium => 0.78,
        AdminDialogSize.large => 0.88,
        AdminDialogSize.xlarge => 0.93,
      };
    }

    final maxDialogHeight = screenHeight * (customHeightFactor ?? heightFactor);
    final minDialogHeight = isMobile ? 220.0 : 260.0;

    return Container(
      width: dialogWidth,
      constraints: BoxConstraints(
        minHeight: minDialogHeight,
        maxHeight: maxDialogHeight,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(theme, isDark),

          // Body Content
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  SizedBox(height: reserveSpace),
                ],
              ),
            ),
          ),

          // Footer
          if (footer != null) ...[
            Divider(height: 1, color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 32,
                vertical: isMobile ? 16 : 24,
              ),
              child: footer!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 20, 16, 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900, 
                letterSpacing: -0.8,
                fontSize: 22,
              ),
            ),
          ),
          IconButton.filledTonal(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, size: 22),
            style: IconButton.styleFrom(
              backgroundColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }
}
