import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/points/presentation/view_model/points_providers.dart';
import 'package:erp/modules/webstore/checkout/presentation/view_model/checkout_view_model.dart';

class PointsRedemptionSectionLogic {
  static Future<double?> previewLoyalty(int selectedPoints, WidgetRef ref) async {
    if (selectedPoints <= 0) return null;

    try {
      final repo = ref.read(pointsRepositoryProvider);
      final result = await repo.previewLoyalty(selectedPoints);
      return result.when(
        success: (data) => (data['discount'] as num?)?.toDouble(),
        failure: (_) => null,
      );
    } catch (_) {
      return null;
    }
  }

  static void applyPoints(
    int selectedPoints,
    WidgetRef ref, {
    int? addressId,
    int? paymentMethodId,
    String? couponCode,
  }) {
    if (selectedPoints <= 0) return;
    ref
        .read(checkoutVmProvider.notifier)
        .calculateTotals(
          addressId: addressId,
          paymentMethodId: paymentMethodId,
          couponCode: couponCode,
          pointsToRedeem: selectedPoints,
        );
  }

  static void cancelPoints(
    WidgetRef ref, {
    int? addressId,
    int? paymentMethodId,
    String? couponCode,
  }) {
    ref
        .read(checkoutVmProvider.notifier)
        .calculateTotals(
          addressId: addressId,
          paymentMethodId: paymentMethodId,
          couponCode: couponCode,
        );
  }
}
