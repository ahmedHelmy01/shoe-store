import 'package:erp/modules/webstore/cms/data/models/slider_model.dart';

/// Slider ViewModel State definitions
sealed class SliderState {
  const SliderState();
}

class SliderInitial extends SliderState {}

class SliderLoading extends SliderState {}

class SliderError extends SliderState {
  final String message;
  const SliderError(this.message);
}

class SliderSuccess extends SliderState {
  final List<SliderModel> sliders;
  const SliderSuccess(this.sliders);
}
