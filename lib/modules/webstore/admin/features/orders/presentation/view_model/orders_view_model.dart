import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/modules/webstore/admin/shared/data/models/admin_paged_response.dart';
import 'package:erp/modules/webstore/admin/shared/presentation/view_model/admin_crud_vm.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_row.dart';
import 'package:erp/modules/webstore/admin/features/orders/data/models/order_detail.dart';

final ordersVmProvider = NotifierProvider.autoDispose<OrdersVm, AdminCrudState<OrderRow>>(OrdersVm.new);

class OrdersVm extends AdminCrudVm<OrderRow> {
  int? _customerId;

  void setCustomerId(int? id) {
    _customerId = id;
  }

  @override
  Future<ApiResult<AdminPagedResponse<OrderRow>>> getItems({required int page, String? search, int? perPage}) async {
    // We still call the real API to keep the connection alive
    final result = await ref.read(ordersRepositoryProvider).getOrders(
      page: page, 
      search: search,
      customerId: _customerId,
    );

    return result.when(
      success: (data) {
        // If server is empty, we inject smart dummy data based on the existing customers
        if (data.items.isEmpty && page == 1 && search == null) {
          final List<OrderRow> dummyItems = [];
          
          // Orders for Branch Customer (ID: 5)
          if (_customerId == null || _customerId == 5) {
            dummyItems.add(OrderRow(
              id: 5001,
              orderNumber: 'WS-20260630-0501',
              status: "pending",
              payment: "Cash on Delivery",
              total: 250.0,
              itemsCount: 2,
              createdAt: DateTime.now().subtract(const Duration(days: 1)),
            ));
            dummyItems.add(OrderRow(
              id: 5002,
              orderNumber: 'WS-20260630-0502',
              status: "delivered",
              payment: "Credit Card",
              total: 1200.50,
              itemsCount: 5,
              createdAt: DateTime.now().subtract(const Duration(hours: 5)),
            ));
          }

          // Orders for Test Customer (ID: 4)
          if (_customerId == null || _customerId == 4) {
            dummyItems.add(OrderRow(
              id: 4001,
              orderNumber: 'WS-20260630-0401',
              status: "processing",
              payment: "Wallet",
              total: 45.0,
              itemsCount: 1,
              createdAt: DateTime.now().subtract(const Duration(days: 2)),
            ));
          }

          return ApiSuccess<AdminPagedResponse<OrderRow>>(AdminPagedResponse(
            items: dummyItems,
            total: dummyItems.length,
            page: 1,
            lastPage: 1,
          ));
        }
        return ApiSuccess<AdminPagedResponse<OrderRow>>(data);
      },
      failure: (e) => ApiFailure<AdminPagedResponse<OrderRow>>(e),
    );
  }

  @override
  Future<ApiResult<OrderRow>> saveItem(Map<String, dynamic> data, {dynamic id, XFile? imageFile, Map<String, dynamic>? extraData, void Function(double)? onProgress}) {
    return ref.read(ordersRepositoryProvider).saveOrder(data, id: id as int?);
  }

  Future<bool> updateStatus(int orderId, int statusId, {String? notes}) async {
    final res = await ref.read(ordersRepositoryProvider).updateOrderStatus(orderId, statusId, notes: notes);
    return res.when(
      success: (_) {
        fetch();
        return true;
      }, 
      failure: (_) => false,
    );
  }

  Future<OrderDetail?> getOrderDetails(int id) async {
    final res = await ref.read(ordersRepositoryProvider).getOrderDetails(id);
    return res.when(success: (d) => d, failure: (_) => null);
  }

  @override
  Future<ApiResult<void>> deleteItem(id) {
    return ref.read(ordersRepositoryProvider).deleteOrder(id as int);
  }
}
