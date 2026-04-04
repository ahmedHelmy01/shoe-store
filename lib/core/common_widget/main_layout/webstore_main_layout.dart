/// WebStore Main Layout
///
/// Bottom navigation shell for the WebStore module.
/// Tabs: Home, Store (Catalog), Cart, Profile.
/// Uses IndexedStack for page caching and smooth tab switching.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/home/presentation/view/webstore_home_screen.dart';

class WebStoreMainLayout extends StatefulWidget {
  final int initialIndex;
  const WebStoreMainLayout({super.key, this.initialIndex = 0});

  @override
  State<WebStoreMainLayout> createState() => _WebStoreMainLayoutState();
}

class _WebStoreMainLayoutState extends State<WebStoreMainLayout> {
  late int _currentIndex;
  DateTime? _lastPressed;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // ─── Tab Screens ───────────────────────────────────

  List<Widget> get _pages => [
        const WebStoreHomeScreen(),
        _PlaceholderPage(
            title: LocaleKeys.webstore.nav.store.tr(),
            icon: Icons.grid_view_rounded),
        _PlaceholderPage(
            title: LocaleKeys.webstore.nav.cart.tr(),
            icon: Icons.shopping_cart_rounded),
        _PlaceholderPage(
            title: LocaleKeys.webstore.nav.profile.tr(),
            icon: Icons.person_rounded),
      ];

  // ─── Tab Config ────────────────────────────────────

  List<_TabItem> get _tabs => [
        _TabItem(
            icon: Icons.home_rounded,
            activeIcon: Icons.home,
            label: LocaleKeys.webstore.nav.home.tr()),
        _TabItem(
            icon: Icons.grid_view_rounded,
            activeIcon: Icons.grid_view,
            label: LocaleKeys.webstore.nav.store.tr()),
        _TabItem(
            icon: Icons.shopping_cart_outlined,
            activeIcon: Icons.shopping_cart,
            label: LocaleKeys.webstore.nav.cart.tr()),
        _TabItem(
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person,
            label: LocaleKeys.webstore.nav.profile.tr()),
      ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // If not on home tab, go to home first
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return;
        }

        // "Press again to exit" behavior
        final now = DateTime.now();
        if (_lastPressed == null ||
            now.difference(_lastPressed!) > const Duration(seconds: 2)) {
          _lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.webstore.general.exit_confirm.tr()),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  // ─── Bottom Nav Bar ────────────────────────────────

  Widget _buildBottomNavBar() {
    final tabs = _tabs;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (index) {
              final tab = tabs[index];
              final isActive = index == _currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            isActive ? tab.activeIcon : tab.icon,
                            key: ValueKey(isActive),
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textHint,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Tab Item Model ──────────────────────────────────

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ─── Placeholder Page ────────────────────────────────

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.webstore.general.coming_soon.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
