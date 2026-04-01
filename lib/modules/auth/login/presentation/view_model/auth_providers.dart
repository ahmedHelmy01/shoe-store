/// Auth Feature State Management (Vertical Slice)
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/auth/login/data/datasource/auth_remote_datasource.dart';
import 'package:erp/modules/auth/login/data/repositories/auth_repository.dart';

/// Auth Remote DataSource Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(networkServiceProvider));
});

/// Auth Repository Provider (Using Interface)
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(ref.watch(authRemoteDataSourceProvider));
});
