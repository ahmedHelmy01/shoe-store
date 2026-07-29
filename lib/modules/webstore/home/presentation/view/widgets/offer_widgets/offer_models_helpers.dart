import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';
import 'package:erp/modules/webstore/catalog/data/models/product_model.dart';
import 'package:erp/modules/webstore/home/presentation/view/widgets/offer_widgets/offer_products_bottom_sheet.dart';

/// Extension to safely get sublists without IndexOutOfBounds exceptions
extension SafeSlice<T> on List<T> {
  List<T> safeSublist(int start, [int? end]) {
    if (start >= length) return [];
    final realEnd = (end == null || end > length) ? length : end;
    return sublist(start, realEnd);
  }
}

/// Converts a StoreOfferProductModel to a WebStoreProduct model for navigation & cart
WebStoreProduct toWebStoreProduct(
  BuildContext context,
  StoreOfferProductModel p,
  StoreOfferModel offer,
) {
  double calculatedPrice = p.customPrice ?? p.salePrice;
  if (p.customPrice == null && offer.discountValue > 0) {
    if (offer.discountType == 1) {
      calculatedPrice = p.salePrice * (1 - (offer.discountValue / 100));
    } else {
      calculatedPrice =
          (p.salePrice - offer.discountValue).clamp(0, double.infinity);
    }
  }

  final isAr = context.locale.languageCode == 'ar';
  return WebStoreProduct(
    id: p.id,
    name: isAr ? (p.nameAr ?? p.name) : (p.nameEn ?? p.name),
    price: calculatedPrice,
    oldPrice: p.salePrice > calculatedPrice ? p.salePrice : null,
    image: p.imageUrl,
    images: p.imageUrl != null ? [p.imageUrl!] : [],
  );
}

/// Opens the BottomSheet displaying the offer's products
void showOfferProductsBottomSheet(BuildContext context, StoreOfferModel offer) {
  if (offer.products.isEmpty) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => OfferProductsBottomSheet(offer: offer),
  );
}
