import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/branches/presentation/state/branch_state.dart';
import 'package:erp/modules/webstore/branches/data/branch_model.dart';
import 'package:erp/modules/webstore/branches/presentation/view_model/branch_providers.dart';

class BranchVm extends Notifier<BranchState> {
  static const _cacheKey = 'webstore_branches_cache';

  @override
  BranchState build() {
    // 1. Try to load cached branches synchronously during initialization for instant offline boot!
    _loadFromCache();
    
    // 2. Trigger asynchronous background fetch to get latest updates
    Future.microtask(() => getBranches());
    return state;
  }

  void _loadFromCache() {
    final prefs = ref.read(sharedPreferencesProvider);
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      try {
        final List<dynamic> json = jsonDecode(cachedData);
        final branches = json.map((e) => BranchModel.fromJson(e as Map<String, dynamic>)).toList();
        state = BranchLoaded(branches);
      } catch (e) {
        debugPrint('❌ BranchVm: Error loading cache: $e');
        state = BranchInitial();
      }
    } else {
      state = BranchInitial();
    }
  }

  Future<void> getBranches() async {
    final prefs = ref.read(sharedPreferencesProvider);
    
    if (state is! BranchLoaded) {
      state = BranchLoading();
    }
    
    final result = await ref.read(branchRepositoryProvider).getBranches();
    
    result.when(
      success: (branches) {
        state = BranchLoaded(branches);
        // Cache the successful branches list
        final listJson = branches.map((e) => e.toJson()).toList();
        prefs.setString(_cacheKey, jsonEncode(listJson));
      },
      failure: (error) {
        debugPrint('❌ BranchVm: Fetch failed: ${error.message}');
        // If we already have cached branches, keep them instead of reverting to error state
        if (state is! BranchLoaded) {
          state = BranchError(error.message);
        }
      },
    );
  }

  Future<void> updateBranch(String branchId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

final branchVmProvider = NotifierProvider<BranchVm, BranchState>(BranchVm.new);
