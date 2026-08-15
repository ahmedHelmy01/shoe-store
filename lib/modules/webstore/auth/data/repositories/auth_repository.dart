import 'package:erp/core/mock/mock_data.dart';
import 'package:erp/core/network/api_result.dart';
import 'package:erp/core/repository/base_repository.dart';
import 'package:erp/modules/webstore/auth/data/models/webstore_auth_response.dart';

abstract class IWebStoreAuthRepository {
  Future<ApiResult<WebStoreAuthResponse>> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    int? branchId,
  });

  Future<ApiResult<WebStoreAuthResponse>> login({
    required String loginName,
    required String password,
  });

  Future<ApiResult<WebStoreAuthResponse>> socialLogin({
    required String providerType,
    required String providerIdentifier,
    String? name,
    String? email,
    String? mobile,
    int? branchId,
  });

  Future<ApiResult<Map<String, dynamic>>> forgotPassword({
    required String username,
  });

  Future<ApiResult<Map<String, dynamic>>> verifyCode({
    required String identifier,
    required String code,
    required String type,
  });

  Future<ApiResult<Map<String, dynamic>>> resendCode({
    required String identifier,
    required String type,
  });

  Future<ApiResult<Map<String, dynamic>>> resetPassword({
    required String identifier,
    required String code,
    required String password,
    required String passwordConfirmation,
  });

  Future<ApiResult<WebStoreAuthResponse>> refreshToken();

  Future<ApiResult<Map<String, dynamic>>> getProfile();

  Future<ApiResult<Map<String, dynamic>>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
  });

  Future<ApiResult<Map<String, dynamic>>> deleteAccount();
}

class WebStoreAuthRepository extends BaseRepository
    implements IWebStoreAuthRepository {
  WebStoreAuthRepository();

  @override
  Future<ApiResult<WebStoreAuthResponse>> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    int? branchId,
  }) {
    return safeApiCall<WebStoreAuthResponse>(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockData.mockAuthResponse;
    });
  }

  @override
  Future<ApiResult<WebStoreAuthResponse>> login({
    required String loginName,
    required String password,
  }) {
    return safeApiCall<WebStoreAuthResponse>(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockData.mockAuthResponse;
    });
  }

  @override
  Future<ApiResult<WebStoreAuthResponse>> socialLogin({
    required String providerType,
    required String providerIdentifier,
    String? name,
    String? email,
    String? mobile,
    int? branchId,
  }) {
    return safeApiCall<WebStoreAuthResponse>(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return MockData.mockAuthResponse;
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> forgotPassword({
    required String username,
  }) {
    return safeApiCall<Map<String, dynamic>>(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return {'message': 'تم إرسال رمز التحقق'};
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> verifyCode({
    required String identifier,
    required String code,
    required String type,
  }) {
    return safeApiCall<Map<String, dynamic>>(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return {'message': 'تم التحقق بنجاح', 'verified': true};
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> resendCode({
    required String identifier,
    required String type,
  }) {
    return safeApiCall<Map<String, dynamic>>(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return {'message': 'تم إرسال الرمز مرة أخرى'};
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> resetPassword({
    required String identifier,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) {
    return safeApiCall<Map<String, dynamic>>(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return {'message': 'تم إعادة تعيين كلمة المرور بنجاح'};
    });
  }

  @override
  Future<ApiResult<WebStoreAuthResponse>> refreshToken() {
    return safeApiCall<WebStoreAuthResponse>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return MockData.mockAuthResponse;
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getProfile() {
    return safeApiCall<Map<String, dynamic>>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return {'data': MockData.mockUser.toJson()};
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateProfile({
    String? name,
    String? email,
    String? mobile,
    String? password,
  }) {
    return safeApiCall<Map<String, dynamic>>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return {'data': MockData.mockUser.toJson()};
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> deleteAccount() {
    return safeApiCall<Map<String, dynamic>>(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return {'message': 'تم حذف الحساب بنجاح'};
    });
  }
}
