import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/common_model/content_management_model.dart';
import 'package:erp/core/common_provider/ads_view_model/ads_state.dart';
import 'package:erp/modules/webstore/home/data/models/webstore_mock_data.dart';

/// Ads View Model
///
/// Fetches and manages Advertisements and Promotion content from CMS.
/// Currently uses Mock data provided in WebStoreMockData.

class AdsVm extends Notifier<AdsState> {
  @override
  AdsState build() {
    return AdsInitial();
  }

  Future<void> getAds() async {
    state = AdsLoading();
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      // Mapping mock ads to the new CMS model for the Vertical Carousel
      final mockData = ContentManagementModel(
        items: WebStoreMockData.ads.map((ad) {
          String content = "عرض خاص";
          if (ad.id == 1) {
            content = "<p style='color:white; font-weight:bold;'>خصم 50% على<br/>منتجات العناية بالبشرة</p>";
          } else if (ad.id == 2) {
            content = "<p style='color:white; font-weight:bold;'>توصيل مجاني<p/><span style='color:#FF6D00; font-size:12px;'>على أول طلب لك</span>";
          }
          
          return ContentManagementItem(
            id: ad.id,
            title: "إعلان",
            image: ad.image,
            content: content,
          );
        }).toList(),
      );

      state = AdsSuccess(mockData);
    } catch (e) {
      state = AdsError(e.toString());
    }
  }
}

final adsVmProvider = NotifierProvider<AdsVm, AdsState>(AdsVm.new);
