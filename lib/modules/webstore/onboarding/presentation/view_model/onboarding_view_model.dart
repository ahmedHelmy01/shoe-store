import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/onboarding/presentation/state/onboarding_state.dart';
import 'package:erp/modules/webstore/shared/data/providers/webstore_providers.dart';
import 'package:erp/modules/webstore/onboarding/data/models/boarding_model.dart';
import 'package:erp/core/utils/asset_manager.dart';

class OnboardingVm extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return OnboardingLoading();
  }

  static final List<BoardingModel> _fallbackBoardings = [
    BoardingModel(
      id: -1,
      title: 'Welcome to Tarshooby Shoes',
      titleAr: 'أهلاً بك في طرشوبي للأحذية',
      content:
          'Step into style with our exclusive collection.',
      contentAr:
          'خطواتك للأناقة تبدأ من هنا مع مجموعتنا الحصرية من الأحذية',
      image: AssetManager.logoElTarshopy,
      position: 0,
    ),
    BoardingModel(
      id: -2,
      title: 'High Quality Shoes',
      titleAr: 'أجود أنواع الأحذية',
      content:
          'Discover the latest trends in fashion and comfortable footwear.',
      contentAr: 'اكتشف أحدث صيحات الموضة والأحذية المريحة لكل المناسبات',
      image: AssetManager.logoElTarshopy,
      position: 1,
    ),
    BoardingModel(
      id: -3,
      title: 'Fast Delivery',
      titleAr: 'توصيل سريع لباب المنزل',
      content: 'Order now and receive your products in the shortest time.',
      contentAr: 'اطلب كل ما تحتاجه الآن واستلمه في أسرع وقت ممكن في أي مكان',
      image: AssetManager.logoElTarshopy,
      position: 2,
    ),
  ];

  Future<void> getOnboardingData() async {
    state = OnboardingLoading();

    final result = await ref.read(boardingRepositoryProvider).getBoardings();

    result.when(
      success: (data) {
        final List<dynamic> boardingsJson = data['data'] ?? [];
        var boardings = boardingsJson
            .map((j) => BoardingModel.fromJson(j))
            .toList();

        if (boardings.isEmpty) {
          boardings = _fallbackBoardings;
        }

        state = OnboardingSuccess(boardings);
      },
      failure: (error) {
        // Fallback even on failure to ensure user experience isn't broken
        state = OnboardingSuccess(_fallbackBoardings);
      },
    );
  }
}

final onboardingVmProvider = NotifierProvider<OnboardingVm, OnboardingState>(
  OnboardingVm.new,
);
