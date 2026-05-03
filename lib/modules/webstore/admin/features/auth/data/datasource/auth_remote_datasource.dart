import 'package:erp/core/network/network_service.dart';
import 'package:erp/core/network/endpoints/endpoints_registry.dart';
import 'package:erp/modules/webstore/admin/features/auth/data/models/admin_user.dart';

class AuthRemoteDataSource {
  final NetworkService _network;

  AuthRemoteDataSource(this._network);

  Future<AdminUser> login(String email, String password) async {
    final res = await _network.post(
      ApiEndpoints.auth.login,
      body: {
        'email': email,
        'password': password,
      },
    );
    final data = (res as Map<String, dynamic>)['data'];
    final token = (res)['token'] as String;
    return AdminUser.fromJson(data).copyWith(token: token);
  }
}
