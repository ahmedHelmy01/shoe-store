import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/branches/data/repositories/webstore_branch_repository.dart';

final branchRepositoryProvider = Provider<IWebStoreBranchRepository>((ref) {
  return WebStoreBranchRepository();
});
