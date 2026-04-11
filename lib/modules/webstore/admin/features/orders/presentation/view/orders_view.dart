import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:erp/modules/webstore/admin/shared/data/fake_data.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/presentation/view/order_list_view.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> with SingleTickerProviderStateMixin {
  static const _statuses = [
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  late TabController _tabController;
  late List<OrderRow> _orders;

  @override
  void initState() {
    super.initState();
    _orders = List<OrderRow>.from(FakeData.orders());
    _tabController = TabController(length: _statuses.length + 1, vsync: this);
    _tabController.addListener(_onTabTick);
  }

  void _onTabTick() {
    if (_tabController.indexIsChanging) return;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabTick);
    _tabController.dispose();
    super.dispose();
  }

  List<OrderRow> _rowsForTab(int tabIndex) {
    if (tabIndex == 0) return _orders;
    final st = _statuses[tabIndex - 1];
    return _orders.where((o) => o.status == st).toList();
  }

  void _setStatus(OrderRow row, String status) {
    final i = _orders.indexWhere((o) => o.id == row.id);
    if (i < 0) return;
    setState(() => _orders[i] = _orders[i].copyWith(status: status));
  }

  @override
  Widget build(BuildContext context) {
    final tabIndex = _tabController.index;
    final items = _rowsForTab(tabIndex);
    return OrderListView(
      tabController: _tabController,
      statuses: _statuses,
      allOrders: _orders,
      visibleRows: items,
      dateFormat: DateFormat('yyyy-MM-dd HH:mm'),
      onStatusChanged: _setStatus,
      onRefresh: () {
        setState(() {
          _orders = List<OrderRow>.from(FakeData.orders());
        });
      },
    );
  }
}
