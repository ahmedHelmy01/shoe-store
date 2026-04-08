import 'package:erp/modules/webstore/onboarding/data/models/boarding_model.dart';

/// Onboarding ViewModel State definitions
sealed class OnboardingState {
  const OnboardingState();
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError(this.message);
}

class OnboardingSuccess extends OnboardingState {
  final List<BoardingModel> boardings;
  const OnboardingSuccess(this.boardings);
}
