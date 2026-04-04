library;

import 'package:erp/core/common_model/content_management_model.dart';

/// Ads ViewModel State definitions
/// Pattern: Sealed Class for type-safe state handling in Consumer widgets.

sealed class AdsState {
  const AdsState();
}

class AdsInitial extends AdsState {}

class AdsLoading extends AdsState {}

class AdsError extends AdsState {
  final String message;
  const AdsError(this.message);
}

class AdsSuccess extends AdsState {
  final ContentManagementModel data;
  const AdsSuccess(this.data);
}
