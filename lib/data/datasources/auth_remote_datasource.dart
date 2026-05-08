import 'package:dio/dio.dart';
import '../../core/http/auth_headers.dart';
import '../models/auth_user_model.dart';

class AuthRemoteDatasource {
  final Dio client;

  AuthRemoteDatasource(this.client);

  Future<AuthUserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await client.post(
      'https://dummyjson.com/auth/login',
      data: {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
    );
    return AuthUserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getCurrentUser(String accessToken) async {
    final response = await client.get(
      'https://dummyjson.com/auth/me',
      options: Options(headers: AuthHeaders.bearer(accessToken)),
    );
    return response.data as Map<String, dynamic>;
  }
}
