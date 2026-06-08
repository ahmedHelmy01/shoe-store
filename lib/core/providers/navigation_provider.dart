import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier to manage the current index of the WebStore main bottom navigation.
class WebStoreNavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

/// Provider to manage the current index of the WebStore main bottom navigation.
final webStoreNavIndexProvider = NotifierProvider<WebStoreNavIndexNotifier, int>(() {
  return WebStoreNavIndexNotifier();
});
