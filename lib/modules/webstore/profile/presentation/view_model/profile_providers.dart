import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/modules/webstore/profile/data/repositories/profile_repository.dart';
import 'package:erp/modules/webstore/profile/presentation/state/profile_state.dart';
import 'package:erp/modules/webstore/profile/presentation/view_model/profile_view_model.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return ProfileRepository();
});

final profileViewModelProvider = NotifierProvider<ProfileViewModel, ProfileState>(() {
  return ProfileViewModel();
});
