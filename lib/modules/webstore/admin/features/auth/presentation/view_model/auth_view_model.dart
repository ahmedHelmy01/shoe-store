import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/admin/core/di/admin_providers.dart';

class LoginState {
  final bool isLoading;
  final String? error;

  const LoginState({this.isLoading = false, this.error});

  LoginState copyWith({bool? isLoading, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final loginVmProvider = NotifierProvider<LoginVm, LoginState>(() {
  return LoginVm();
});

class LoginVm extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.login(email, password);

    return result.when(
      success: (user) async {
        if (user.token != null) {
          await ref.read(authStateProvider.notifier).setAuthenticated(
            token: user.token!,
            userId: user.id.toString(),
          );
          state = const LoginState();
          return true;
        } else {
          state = state.copyWith(isLoading: false, error: 'Login succeeded but no token returned');
          return false;
        }
      },
      failure: (err) {
        state = state.copyWith(isLoading: false, error: err.message);
        return false;
      },
    );
  }
}
