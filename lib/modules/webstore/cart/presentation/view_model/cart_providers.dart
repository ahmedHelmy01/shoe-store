import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/cart/data/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  return CartRepository();
});
