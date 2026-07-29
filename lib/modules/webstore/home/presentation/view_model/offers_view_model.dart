import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/home/data/models/store_offer_model.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';

class OffersState {
  final List<StoreOfferModel> offers;
  final bool isLoading;
  final String? errorMessage;

  const OffersState({
    this.offers = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  OffersState copyWith({
    List<StoreOfferModel>? offers,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OffersState(
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OffersVm extends Notifier<OffersState> {
  static const _cacheKey = 'webstore_offers_cache';

  @override
  OffersState build() {
    final cachedData = _loadFromCache();
    Future.microtask(() => getOffers());
    return OffersState(
      offers: cachedData,
      isLoading: cachedData.isEmpty,
    );
  }

  List<StoreOfferModel> _loadFromCache() {
    final prefs = ref.read(sharedPreferencesProvider);
    final cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      try {
        final List<dynamic> json = jsonDecode(cachedData);
        return json.map((j) => StoreOfferModel.fromJson(j as Map<String, dynamic>)).toList();
      } catch (e) {
        debugPrint('❌ OffersVm: Error loading cache: $e');
      }
    }
    return [];
  }

  Future<void> getOffers() async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (state.offers.isEmpty) {
      state = state.copyWith(isLoading: true);
    }

    final result = await ref.read(cmsRepositoryProvider).getOffers();

    result.when(
      success: (offers) {
        state = state.copyWith(
          offers: offers,
          isLoading: false,
          errorMessage: null,
        );

        final jsonList = offers.map((o) => o.toJson()).toList();
        prefs.setString(_cacheKey, jsonEncode(jsonList));
      },
      failure: (error) {
        debugPrint('❌ OffersVm: Fetch offers failed: ${error.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: error.message,
        );
      },
    );
  }
}

final offersVmProvider = NotifierProvider<OffersVm, OffersState>(OffersVm.new);
