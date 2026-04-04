/// WebStore Auth Providers
///
/// Riverpod providers for the WebStore auth feature.
/// Wires: DataSource → Repository → ViewModel
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/auth/data/datasource/webstore_auth_remote_datasource.dart';
import 'package:erp/modules/webstore/auth/data/repositories/auth_repository.dart';
import 'package:erp/modules/webstore/auth/presentation/state/webstore_auth_state.dart';
import 'package:erp/modules/webstore/auth/presentation/view_model/webstore_auth_view_model.dart';

/// WebStore Auth DataSource Provider
final webStoreAuthDataSourceProvider =
    Provider<WebStoreAuthRemoteDataSource>((ref) {
  return WebStoreAuthRemoteDataSource(ref.watch(networkServiceProvider));
});

/// WebStore Auth Repository Provider (Interface-based)
final webStoreAuthRepositoryProvider =
    Provider<IWebStoreAuthRepository>((ref) {
  return WebStoreAuthRepository(ref.watch(webStoreAuthDataSourceProvider));
});

/// WebStore Auth ViewModel Provider (Riverpod 3.0 Notifier)
final webStoreAuthViewModelProvider =
    NotifierProvider<WebStoreAuthViewModel, WebStoreAuthState>(() {
  return WebStoreAuthViewModel();
});
