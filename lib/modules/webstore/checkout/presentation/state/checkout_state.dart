import 'package:flutter/foundation.dart';

@immutable
abstract class CheckoutState {
  const CheckoutState();
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

class CheckoutSummaryLoaded extends CheckoutState {
  final Map<String, dynamic> summary;

  const CheckoutSummaryLoaded(this.summary);
}

class CheckoutSubmitting extends CheckoutState {
  const CheckoutSubmitting();
}

class CheckoutSuccess extends CheckoutState {
  final Map<String, dynamic> orderResult;

  const CheckoutSuccess(this.orderResult);
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);
}
