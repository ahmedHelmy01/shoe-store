import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/branches/data/datasource/webstore_branch_remote_datasource.dart';
import 'package:erp/modules/webstore/branches/data/repositories/webstore_branch_repository.dart';

final branchRemoteDataSourceProvider = Provider<WebStoreBranchRemoteDataSource>((ref) {
  return WebStoreBranchRemoteDataSource(ref.watch(networkServiceProvider));
});

final branchRepositoryProvider = Provider<IWebStoreBranchRepository>((ref) {
  return WebStoreBranchRepository(ref.watch(branchRemoteDataSourceProvider));
});
