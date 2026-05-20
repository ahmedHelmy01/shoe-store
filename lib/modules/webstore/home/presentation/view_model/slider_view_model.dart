import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/home/presentation/state/slider_state.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/home/data/models/slider_model.dart';
import 'package:erp/core/providers/core_providers.dart';

// ─── Slider View Model ──────────────────────────────

class SliderVm extends Notifier<SliderState> {
  @override
  SliderState build() {
    Future.microtask(() => getSliders());
    return SliderInitial();
  }

  Future<void> getSliders() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final cacheKey = 'webstore_sliders_cache';

    state = SliderLoading();

    // Attempt 1
    var result = await ref.read(cmsRepositoryProvider).getSliders();

    // Retry Logic
    if (result.isFailure) {
      await Future.delayed(const Duration(seconds: 1));
      result = await ref.read(cmsRepositoryProvider).getSliders();
    }

    result.when(
      success: (data) {
        final List<dynamic> sliderJson = data['data'] ?? [];
        final sliders = sliderJson.map((j) => SliderModel.fromJson(j)).toList();
        state = SliderSuccess(sliders);
        
        // Cache successful result
        prefs.setString(cacheKey, jsonEncode(data));
      },
      failure: (error) {
        debugPrint('❌ SliderVm: Fetch failed: ${error.message}');
        
        // Try cache
        final cachedData = prefs.getString(cacheKey);
        if (cachedData != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(cachedData);
            final List<dynamic> sliderJson = data['data'] ?? [];
            final sliders = sliderJson.map((j) => SliderModel.fromJson(j)).toList();
            state = SliderSuccess(sliders);
          } catch (e) {
            debugPrint('Error parsing cached sliders: $e');
            state = SliderError(error.message);
          }
        } else {
          state = SliderError(error.message);
        }
      },
    );
  }
}

final sliderVmProvider = NotifierProvider<SliderVm, SliderState>(SliderVm.new);
