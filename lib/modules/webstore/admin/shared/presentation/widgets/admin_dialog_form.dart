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

  const AdminDialogForm({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.title,
    required this.child,
    this.footer,
    this.size = AdminDialogSize.medium,
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
          onTap: onClose,
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
            child: _buildDialogContent(context, isMobile, theme, isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogContent(BuildContext context, bool isMobile, ThemeData theme, bool isDark) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    
    // Unified Desktop width (around 720px) as preferred by the user.
    // Small size is now only for mobile.
    double dialogWidth;
    if (isMobile) {
      dialogWidth = screenWidth * 0.92;
    } else {
      // Consistent medium-large width for a professional web feel
      dialogWidth = 720.0;
      if (dialogWidth > screenWidth * 0.9) dialogWidth = screenWidth * 0.9;
    }

    final dialogHeight = isMobile ? screenHeight * 0.85 : screenHeight * 0.88;

    return Container(
      width: dialogWidth,
      height: dialogHeight,
      constraints: BoxConstraints(maxHeight: dialogHeight),
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
        children: [
          // Header
          _buildHeader(theme, isDark),

          // Body Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              child: child,
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
