import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login({
    required String username,
    required String password,
  });

  Future<Map<String, dynamic>> getCurrentUser(String accessToken);

  Future<void> logout();
}
