import 'package:erp/modules/webstore/auth/data/models/webstore_user_model.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final WebStoreUser user;
  const ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}

class ProfileUpdateSuccess extends ProfileState {
  final WebStoreUser user;
  final String message;
  const ProfileUpdateSuccess(this.user, this.message);
}

class ProfileDeleted extends ProfileState {
  const ProfileDeleted();
}
