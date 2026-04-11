import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/network/network_service.dart';
import '../datasource/webstore_admin_remote_datasource.dart';
import '../repositories/webstore_admin_repository.dart';

final webStoreAdminRemoteDataSourceProvider = Provider<WebStoreAdminRemoteDataSource>((ref) {
  return WebStoreAdminRemoteDataSource(ref.read(networkServiceProvider));
});

final webStoreAdminRepositoryProvider = Provider<IWebStoreAdminRepository>((ref) {
  return WebStoreAdminRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});
