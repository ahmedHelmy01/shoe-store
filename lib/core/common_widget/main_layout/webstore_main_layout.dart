import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/constants/app_constants.dart';
import 'package:erp/core/localization/locale_keys.dart';
import 'package:erp/modules/webstore/home/presentation/view/webstore_home_screen.dart';
import 'package:erp/modules/webstore/catalog/presentation/view/webstore_categories_view.dart';
import 'package:erp/modules/webstore/cart/presentation/view/webstore_cart_view.dart';
import 'package:erp/modules/webstore/profile/presentation/view/webstore_profile_view.dart';
import 'package:erp/modules/webstore/cms/presentation/view/webstore_more_view.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/core/router/app_navigator.dart';

class WebStoreMainLayout extends ConsumerStatefulWidget {
  final int initialIndex;
  const WebStoreMainLayout({super.key, this.initialIndex = 0});

  @override
  ConsumerState<WebStoreMainLayout> createState() => _WebStoreMainLayoutState();
}

class _WebStoreMainLayoutState extends ConsumerState<WebStoreMainLayout> {
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
        const WebStoreCategoriesView(),
        const WebStoreCartView(),
        WebStoreProfileView(key: ValueKey(_currentIndex == 3)),
        const WebStoreMoreView(),
      ];

  // ─── Tab Config ────────────────────────────────────

  List<_TabItem> _tabs(BuildContext context) => [
        _TabItem(
          icon: Icons.home_rounded,
          activeIcon: Icons.home,
          label: LocaleKeys.webstore.nav.home.tr(context: context),
        ),
        _TabItem(
          icon: Icons.grid_view_rounded,
          activeIcon: Icons.grid_view,
          label: LocaleKeys.webstore.nav.store.tr(context: context),
        ),
        _TabItem(
          icon: Icons.shopping_cart_outlined,
          activeIcon: Icons.shopping_cart,
          label: LocaleKeys.webstore.nav.cart.tr(context: context),
        ),
        _TabItem(
          icon: Icons.person_outline_rounded,
          activeIcon: Icons.person,
          label: LocaleKeys.webstore.nav.profile.tr(context: context),
        ),
        _TabItem(
          icon: Icons.menu_rounded,
          activeIcon: Icons.menu_open_rounded,
          label: LocaleKeys.webstore.nav.more.tr(context: context),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
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
              content: Text(LocaleKeys.webstore.general.exit_confirm.tr(context: context)),
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
        bottomNavigationBar: _buildBottomNavBar(auth),
      ),
    );
  }

  // ─── Bottom Nav Bar ────────────────────────────────

  Widget _buildBottomNavBar(AuthState auth) {
    final theme = Theme.of(context);
    final tabs = _tabs(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
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
                  onTap: () {
                    final requiresAuth = index == 2 || index == 3; // Cart, Profile
                    final isAuthed = auth.status == AuthStatus.authenticated;
                    if (requiresAuth && !isAuthed) {
                      AppNavigator.push(context, AppRouteNames.webstoreLogin);
                      return;
                    }
                    setState(() => _currentIndex = index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary.withValues(alpha: 0.1)
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
                                : theme.hintColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'Harmattan',
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive
                                ? AppColors.primary
                                : theme.hintColor,
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
