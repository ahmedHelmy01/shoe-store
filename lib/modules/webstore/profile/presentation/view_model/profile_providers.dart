import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/profile/data/datasource/profile_remote_datasource.dart';
import 'package:erp/modules/webstore/profile/data/repositories/profile_repository.dart';
import 'package:erp/modules/webstore/profile/presentation/state/profile_state.dart';
import 'package:erp/modules/webstore/profile/presentation/view_model/profile_view_model.dart';

final profileDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(ref.watch(networkServiceProvider));
});

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return ProfileRepository(ref.watch(profileDataSourceProvider));
});

final profileViewModelProvider = NotifierProvider<ProfileViewModel, ProfileState>(() {
  return ProfileViewModel();
});
