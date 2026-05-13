import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_model/content_management_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/ads/ads_state.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/home/data/models/ad_model.dart';
import 'package:erp/core/providers/core_providers.dart';

class AdsVm extends Notifier<AdsState> {
  @override
  AdsState build() {
    Future.microtask(() => getAds());
    return AdsInitial();
  }

  Future<void> getAds() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final cacheKey = 'webstore_ads_cache';

    state = AdsLoading();

    final result = await ref.read(cmsRepositoryProvider).getAds();

    result.when(
      success: (data) {
        final List<dynamic> adsJson = data['data'] ?? [];
        final ads = adsJson.map((j) => AdModel.fromJson(j)).toList();

        final mappedData = _mapAds(ads);
        state = AdsSuccess(mappedData);

        // Cache result
        prefs.setString(cacheKey, jsonEncode(data));
      },
      failure: (error) {
        debugPrint('❌ AdsVm: Fetch failed: ${error.message}');
        
        // Try cache
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(cachedData);
            final List<dynamic> adsJson = data['data'] ?? [];
            final ads = adsJson.map((j) => AdModel.fromJson(j)).toList();
            state = AdsSuccess(_mapAds(ads));
          } catch (e) {
            debugPrint('Error parsing cached ads: $e');
            state = AdsError(error.message);
          }
        } else {
          state = AdsError(error.message);
        }
      },
    );
  }

  ContentManagementModel _mapAds(List<AdModel> ads) {
    return ContentManagementModel(
      items: ads
          .map(
            (ad) => ContentManagementItem(
              id: ad.id,
              title: ad.titleAr,
              image: ad.image ?? '',
              content: ad.title,
            ),
          )
          .toList(),
    );
  }
}

final adsVmProvider = NotifierProvider<AdsVm, AdsState>(AdsVm.new);
