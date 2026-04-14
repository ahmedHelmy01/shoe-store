import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/admin/data/datasource/webstore_admin_remote_datasource.dart';
import 'package:erp/modules/webstore/admin/data/repositories/webstore_admin_repository.dart';

final webStoreAdminRemoteDataSourceProvider = Provider<WebStoreAdminRemoteDataSource>((ref) {
  return WebStoreAdminRemoteDataSource(ref.read(networkServiceProvider));
});

final webStoreAdminRepositoryProvider = Provider<IWebStoreAdminRepository>((ref) {
  return WebStoreAdminRepository(ref.read(webStoreAdminRemoteDataSourceProvider));
});
