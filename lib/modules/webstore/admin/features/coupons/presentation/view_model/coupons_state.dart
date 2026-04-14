import 'package:erp/modules/webstore/admin/features/coupons/data/models/coupon_row.dart';

sealed class CouponsState {
  const CouponsState();
}

class CouponsLoading extends CouponsState {
  const CouponsLoading();
}

class CouponsError extends CouponsState {
  final String message;
  const CouponsError(this.message);
}

class CouponsData extends CouponsState {
  final List<CouponRow> items;
  final int page;
  final int? lastPage;
  final int? total;
  final String search;

  const CouponsData({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    required this.search,
  });

  bool get canPrev => page > 1;
  bool get canNext => lastPage == null ? items.isNotEmpty : page < (lastPage ?? page);
}
