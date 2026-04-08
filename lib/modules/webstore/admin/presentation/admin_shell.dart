import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/modules/webstore/admin/presentation/admin_routes.dart';
import 'package:erp/modules/webstore/admin/presentation/widgets/admin_sidebar.dart';
import 'package:erp/modules/webstore/admin/presentation/widgets/admin_top_bar.dart';
import 'package:erp/modules/webstore/admin/presentation/features/dashboard/view/admin_dashboard_view.dart';
import 'package:erp/modules/webstore/admin/presentation/features/settings/view/admin_placeholder_view.dart';
import 'package:erp/modules/webstore/admin/presentation/features/catalog/products/list/view/admin_products_view.dart';
import 'package:erp/modules/webstore/admin/presentation/features/catalog/categories/list/view/admin_categories_view.dart';
import 'package:erp/modules/webstore/admin/presentation/features/catalog/companies/list/view/admin_companies_view.dart';
import 'package:erp/modules/webstore/admin/presentation/features/catalog/filters/list/view/admin_filters_view.dart';
import 'package:erp/modules/webstore/admin/presentation/features/users/list/view/admin_users_view.dart';
import 'package:erp/modules/webstore/admin/presentation/features/orders/order_list/page/order_list_page.dart';
import 'package:erp/modules/webstore/admin/presentation/features/orders/order_create/page/order_create_page.dart';
import 'package:erp/core/router/app_navigator.dart';

class AdminShell extends StatefulWidget {
  final AdminRouteId initial;

  const AdminShell({super.key, this.initial = AdminRouteId.dashboard});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AdminRouteId _selected;
  bool _collapsed = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  bool _isWide(double width) => width >= 980;

  void _select(AdminRouteId id) {
    if (_selected == id) return;
    setState(() => _selected = id);

    // Update URL on web via named routes (keeps deep-links).
    final routeName = AdminRoutes.toRouteName(id);
    if (ModalRoute.of(context)?.settings.name != routeName) {
      AppNavigator.replace(context, routeName);
    }
  }

  void _toggleNav({required bool wide}) {
    if (!wide) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      setState(() => _collapsed = !_collapsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF07121F) : const Color(0xFFF4F6FB);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = _isWide(constraints.maxWidth);

        final sidebar = AdminSidebar(
          selected: _selected,
          onSelect: (id) {
            _select(id);
            if (!wide) Navigator.of(context).maybePop();
          },
          collapsed: wide ? _collapsed : false,
        );

        final title = AdminRoutes.titleOf(_selected);

        return WebStoreBaseScaffold(
          scaffoldKey: _scaffoldKey,
          showAppBar: false,
          backgroundColor: bg,
          drawer: wide ? null : Drawer(child: sidebar),
          body: SafeArea(
            child: Row(
              children: [
                if (wide) sidebar,
                Expanded(
                  child: Column(
                    children: [
                      AdminTopBar(
                        title: title,
                        onToggleNav: () => _toggleNav(wide: wide),
                        isNavCollapsed: _collapsed,
                        showHamburger: !wide,
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, anim) {
                            final slide = Tween<Offset>(
                              begin: const Offset(0.02, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
                            return FadeTransition(
                              opacity: anim,
                              child: SlideTransition(position: slide, child: child),
                            );
                          },
                          child: _buildBody(key: ValueKey(_selected)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody({required Key key}) {
    return switch (_selected) {
      AdminRouteId.dashboard => const AdminDashboardView(key: ValueKey('dash')),
      AdminRouteId.users => const AdminUsersView(),
      AdminRouteId.products => const AdminProductsView(),
      AdminRouteId.categories => const AdminCategoriesView(),
      AdminRouteId.companies => const AdminCompaniesView(),
      AdminRouteId.filters => const AdminFiltersView(),
      AdminRouteId.orderGroup => const OrderListPage(),
      AdminRouteId.orders => const OrderListPage(),
      AdminRouteId.orderCreate => const OrderCreatePage(),
      AdminRouteId.settings => AdminPlaceholderView(
          key: key,
          title: 'Settings',
          subtitle: 'Configure storefront behavior, delivery, payments, and branding.',
          icon: Icons.settings_rounded,
        ),
      AdminRouteId.catalog => const AdminProductsView(),
    };
  }
}

