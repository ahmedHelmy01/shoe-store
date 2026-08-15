/// WebStore Auth Providers
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/auth/data/repositories/auth_repository.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_view_model.dart';

/// WebStore Auth Repository Provider (Interface-based)
final webStoreAuthRepositoryProvider =
    Provider<IWebStoreAuthRepository>((ref) {
  return WebStoreAuthRepository();
});

/// WebStore Auth ViewModel Provider (Riverpod 3.0 Notifier)
final webStoreAuthViewModelProvider =
    NotifierProvider<WebStoreAuthViewModel, WebStoreAuthState>(() {
  return WebStoreAuthViewModel();
});
