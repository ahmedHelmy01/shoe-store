import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_model/content_management_model.dart';
import 'package:erp/modules/webstore/home/presentation/view_model/ads/ads_state.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/home/data/models/ad_model.dart';

class AdsVm extends Notifier<AdsState> {
  @override
  AdsState build() {
    return AdsInitial();
  }

  Future<void> getAds() async {
    state = AdsLoading();

    final result = await ref.read(cmsRepositoryProvider).getAds();

    result.when(
      success: (data) {
        final List<dynamic> adsJson = data['data'] ?? [];
        final ads = adsJson.map((j) => AdModel.fromJson(j)).toList();

        // Mapping to ContentManagementModel to avoid breaking AdsSection UI
        final mappedData = ContentManagementModel(
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

        state = AdsSuccess(mappedData);
      },
      failure: (error) {
        state = AdsError(error.message);
      },
    );
  }
}

final adsVmProvider = NotifierProvider<AdsVm, AdsState>(AdsVm.new);
