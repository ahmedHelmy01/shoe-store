import 'package:erp/modules/webstore/onboarding/data/models/boarding_model.dart';

/// Onboarding ViewModel State definitions
sealed class OnboardingState {
  const OnboardingState();
}

class OnboardingLoading extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {
  final List<BoardingModel> boardings;
  const OnboardingSuccess(this.boardings);
}
