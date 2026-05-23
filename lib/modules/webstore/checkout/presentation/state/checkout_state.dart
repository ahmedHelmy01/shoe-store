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

class CheckoutValidating extends CheckoutState {
  const CheckoutValidating();
}

class CheckoutValidated extends CheckoutState {
  final Map<String, dynamic> result;
  const CheckoutValidated(this.result);
}

class CheckoutCalculating extends CheckoutState {
  const CheckoutCalculating();
}

class CheckoutCalculated extends CheckoutState {
  final Map<String, dynamic> calculations;
  const CheckoutCalculated(this.calculations);
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
