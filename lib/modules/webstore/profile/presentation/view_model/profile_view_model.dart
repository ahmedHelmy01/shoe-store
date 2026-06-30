import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';
import 'package:erp/modules/webstore/profile/presentation/state/profile_state.dart';
import 'package:erp/modules/webstore/profile/presentation/view_model/profile_providers.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  static const _cacheKey = 'webstore_profile_cache';

  @override
  ProfileState build() {
    final auth = ref.watch(authStateProvider);
    if (auth.status != AuthStatus.authenticated) {
      // Clear cache when logged out
      final prefs = ref.read(sharedPreferencesProvider);
      prefs.remove(_cacheKey);
      return const ProfileInitial();
    }
    // Load from local storage cache first for instant offline access
    _loadFromCache();
    return const ProfileInitial();
  }

  void _loadFromCache() {
    final prefs = ref.read(sharedPreferencesProvider);
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      try {
        final user = WebStoreUser.fromJson(jsonDecode(cachedData));
        state = ProfileLoaded(user);
      } catch (e) {
        debugPrint('❌ ProfileViewModel: Error loading cache: $e');
      }
    }
  }

  void _saveToCache(WebStoreUser user) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_cacheKey, jsonEncode(user.toJson()));
  }

  Future<void> getProfile() async {
    final auth = ref.read(authStateProvider);
    if (auth.status != AuthStatus.authenticated) {
      state = const ProfileInitial();
      return;
    }

    // If not loaded yet, set loading. If already has cached state, keep it and load in background
    if (state is! ProfileLoaded) {
      state = const ProfileLoading();
    }

    final result = await ref.read(profileRepositoryProvider).getProfile();
    result.when(
      success: (user) {
        _saveToCache(user);
        state = ProfileLoaded(user);
      },
      failure: (error) {
        debugPrint('❌ ProfileViewModel: Failed to fetch profile: ${error.message}');
        if (state is! ProfileLoaded) {
          state = ProfileError(error.message);
        }
      },
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String mobile,
    String? password,
    int? branchId,
  }) async {
    state = const ProfileLoading();

    final result = await ref.read(profileRepositoryProvider).updateProfile(
          name: name,
          email: email,
          mobile: mobile,
          password: password,
          branchId: branchId,
        );

    result.when(
      success: (user) {
        _saveToCache(user);
        state = ProfileUpdateSuccess(user, 'profile.update_success');
      },
      failure: (error) {
        state = ProfileError(error.message);
      },
    );
  }

  Future<void> deleteAccount() async {
    state = const ProfileLoading();

    final result = await ref.read(profileRepositoryProvider).deleteAccount();
    result.when(
      success: (_) async {
        // Clear local storage and tokens
        final prefs = ref.read(sharedPreferencesProvider);
        await prefs.remove(_cacheKey);
        await ref.read(sessionManagerProvider).clearSession();
        ref.read(authStateProvider.notifier).setUnauthenticated();
        state = const ProfileDeleted();
      },
      failure: (error) {
        state = ProfileError(error.message);
      },
    );
  }

  void resetState() {
    // Reload from cache to clear any temporary error or update state
    _loadFromCache();
    if (state is! ProfileLoaded) {
      state = const ProfileInitial();
    }
  }
}
