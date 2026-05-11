import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/branches/presentation/state/branch_state.dart';
import 'package:erp/modules/webstore/home/data/cms_repository.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';

class BranchVm extends Notifier<BranchState> {
  @override
  BranchState build() {
    Future.microtask(() => getBranches());
    return BranchInitial();
  }

  Future<void> getBranches() async {
    state = BranchLoading();
    final result = await ref.read(cmsRepositoryProvider).getBranches();
    
    result.when(
      success: (branches) => state = BranchLoaded(branches),
      failure: (error) => state = BranchError(error.message),
    );
  }

  Future<void> updateBranch(String branchId) async {
    // This method would call an API if needed to update the backend session
    // For now, it's a placeholder as requested in the user's snippet
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

final branchVmProvider = NotifierProvider<BranchVm, BranchState>(BranchVm.new);
