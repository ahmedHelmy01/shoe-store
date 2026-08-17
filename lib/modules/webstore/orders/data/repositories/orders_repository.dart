import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';

abstract class IOrdersRepository {
  Future<ApiResult<Map<String, dynamic>>> getOrders({Map<String, dynamic>? queryParams});
  Future<ApiResult<Map<String, dynamic>>> getOrderDetail(int id);
  Future<ApiResult<Map<String, dynamic>>> cancelOrder(int id, {String? reason});
  Future<ApiResult<Map<String, dynamic>>> rateOrder(int id, {required int rating, String? ratingText});
  Future<ApiResult<Map<String, dynamic>>> getOrderRating(int id);
  Future<ApiResult<dynamic>> trackOrder(int id);
  Future<ApiResult<dynamic>> reorder(int orderId);
}

class OrdersRepository extends BaseRepository implements IOrdersRepository {
  OrdersRepository();

  @override
  Future<ApiResult<Map<String, dynamic>>> getOrders({Map<String, dynamic>? queryParams}) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {
          'data': MockData.mockOrders,
        };
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getOrderDetail(int id) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {'data': MockData.mockOrderDetail};
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> cancelOrder(int id, {String? reason}) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {'message': 'تم إلغاء الطلب بنجاح'};
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> rateOrder(int id, {required int rating, String? ratingText}) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {'message': 'تم تقييم الطلب بنجاح'};
      });

  @override
  Future<ApiResult<Map<String, dynamic>>> getOrderRating(int id) =>
      safeApiCall<Map<String, dynamic>>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {'rating': 5, 'review': 'ممتاز'};
      });

  @override
  Future<ApiResult<dynamic>> trackOrder(int id) =>
      safeApiCall<dynamic>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        final now = DateTime.now();
        String iso(DateTime d) => d.toIso8601String();
        return {
          'data': {
            'status': 'shipped',
            'status_label': 'قيد الشحن',
            'estimated_delivery': '2026-08-20',
            'tracking': [
              {
                'status': 'تم تأكيد الطلب',
                'notes': 'تم استلام طلبك بنجاح من المتجر',
                'date': iso(now.subtract(const Duration(hours: 26))),
                'color': '#5C1629',
              },
              {
                'status': 'جاري تجهيز الطلب',
                'notes': 'يتم تجهيز منتجاتك في الفرع',
                'date': iso(now.subtract(const Duration(hours: 20))),
                'color': '#7B1E3B',
              },
              {
                'status': 'تم الشحن',
                'notes': 'تم تسليم الطلب لشركة التوصيل',
                'date': iso(now.subtract(const Duration(hours: 8))),
                'color': '#9C3353',
              },
              {
                'status': 'قيد التوصيل',
                'notes': 'سائق التوصيل في الطريق إليك',
                'date': iso(now.subtract(const Duration(minutes: 30))),
                'color': '#B04A6C',
              },
              {
                'status': 'التسليم المتوقع',
                'notes': 'من المتوقع وصول طلبك اليوم',
                'date': iso(now.add(const Duration(hours: 4))),
                'color': '#7B1E3B',
              },
            ],
          },
        };
      });

  @override
  Future<ApiResult<dynamic>> reorder(int orderId) =>
      safeApiCall<dynamic>(() async {
        await Future.delayed(const Duration(milliseconds: 300));
        return {'message': 'تمت الإضافة للسلة بنجاح'};
      });
}
