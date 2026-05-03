import 'package:flutter/material.dart';
import 'package:erp/core/common_widget/main_layout/webstore_base_scaffold.dart';
import 'package:erp/core/router/app_navigator.dart';
import 'package:erp/modules/webstore/admin/core/admin_routes.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/AdminSidebar/AdminSidebar.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/widgets/admin_top_bar.dart';

// Feature Views
import 'package:erp/modules/webstore/admin/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:erp/modules/webstore/admin/features/settings/presentation/view/settings_view.dart';
import 'package:erp/modules/webstore/admin/features/users/presentation/view/users_view.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view/orders_management/orders_view.dart';

import 'package:erp/modules/webstore/admin/features/catalog/products/presentation/view/products_view.dart';
import 'package:erp/modules/webstore/admin/features/catalog/presentation/view/catalog_view.dart';
import 'package:erp/modules/webstore/admin/features/catalog/categories/presentation/view/categories_view.dart';
import 'package:erp/modules/webstore/admin/features/catalog/companies/presentation/view/companies_view.dart';
import 'package:erp/modules/webstore/admin/features/catalog/filters/presentation/view/filters_view.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view/order_create/order_create_view.dart';
import 'package:erp/modules/webstore/admin/features/auth/presentation/view/login_view.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:erp/modules/webstore/admin/features/ads/presentation/view/ads_view.dart';
import 'package:erp/modules/webstore/admin/features/boardings/presentation/view/boardings_view.dart';
import 'package:erp/modules/webstore/admin/features/branches/presentation/view/branches_view.dart';
import 'package:erp/modules/webstore/admin/features/cities/presentation/view/cities_view.dart';
import 'package:erp/modules/webstore/admin/features/coupons/presentation/view/coupons_view.dart';
import 'package:erp/modules/webstore/admin/features/governorates/presentation/view/governorates_view.dart';
import 'package:erp/modules/webstore/admin/features/pages/presentation/view/pages_view.dart';
import 'package:erp/modules/webstore/admin/features/payment_methods/presentation/view/payment_methods_view.dart';
import 'package:erp/modules/webstore/admin/features/payment_statuses/presentation/view/payment_statuses_view.dart';
import 'package:erp/modules/webstore/admin/features/properties/presentation/view/properties_view.dart';
import 'package:erp/modules/webstore/admin/features/sliders/presentation/view/sliders_view.dart';
import 'package:erp/modules/webstore/admin/features/order_statuses/presentation/view/order_statuses_view.dart';
import 'package:erp/modules/webstore/admin/features/customers/customer_groups/presentation/view/customer_groups_view.dart';
import 'package:erp/modules/webstore/admin/features/customers/reports/presentation/view/client_reports_view.dart';
import 'package:erp/modules/webstore/admin/features/warehouses/presentation/view/warehouses_view.dart';
import 'package:erp/modules/webstore/admin/features/contacts/presentation/view/contacts_view.dart';

class AdminShell extends ConsumerStatefulWidget {
  final AdminRouteId initial;

  const AdminShell({super.key, this.initial = AdminRouteId.dashboard});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
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
        final authStatus = ref.watch(authStateProvider.select((s) => s.status));

        if (authStatus == AuthStatus.initial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (authStatus == AuthStatus.unauthenticated) {
          return const LoginView();
        }

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
      AdminRouteId.dashboard => const DashboardView(),
      AdminRouteId.users => const UsersView(),
      AdminRouteId.products => const ProductsView(),
      AdminRouteId.categories => const CategoriesView(),
      AdminRouteId.companies => const CompaniesView(),
      AdminRouteId.filters => const FiltersView(),
      AdminRouteId.orderGroup => const OrdersView(),
      AdminRouteId.orders => const OrdersView(),
      AdminRouteId.orderCreate => const OrderCreateView(),
      AdminRouteId.orderStatuses => const OrderStatusesView(),
      AdminRouteId.coupons => const CouponsView(),
      AdminRouteId.branches => const BranchesView(),
      AdminRouteId.warehouses => const WarehousesView(),
      AdminRouteId.sliders => const SlidersView(),
      AdminRouteId.ads => const AdsView(),
      AdminRouteId.boardings => const BoardingsView(),
      AdminRouteId.pages => const PagesView(),
      AdminRouteId.properties => const PropertiesView(),
      AdminRouteId.paymentStatuses => const PaymentStatusesView(),
      AdminRouteId.paymentMethods => const PaymentMethodsView(),
      AdminRouteId.cities => const CitiesView(),
      AdminRouteId.governorates => const GovernoratesView(),
      AdminRouteId.settings => SettingsView(
          key: key,
          title: 'Settings',
          subtitle: 'Configure storefront behavior, delivery, payments, and branding.',
          icon: Icons.settings_rounded,
        ),
      AdminRouteId.catalog => const CatalogView(),
      AdminRouteId.operations => const BranchesView(),
      AdminRouteId.storefront => const SlidersView(),
      AdminRouteId.customerGroup => const UsersView(),
      AdminRouteId.customerGroups => const CustomerGroupsView(),
      AdminRouteId.clientReports => const ClientReportsView(),
      AdminRouteId.contacts => const ContactsView(),
      AdminRouteId.supportGroup => const ContactsView(),
      AdminRouteId.login => const LoginView(),
    };
  }
}
