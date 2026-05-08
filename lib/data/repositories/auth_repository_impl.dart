import 'package:dio/dio.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    try {
      final model = await remote.login(
        username: username,
        password: password,
      );
      return model.toEntity();
    } on DioException catch (e) {
      throw Failure(_translateDioError(e));
    } catch (_) {
      throw Failure('Erro inesperado ao fazer login');
    }
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser(String accessToken) async {
    try {
      return await remote.getCurrentUser(accessToken);
    } on DioException catch (e) {
      throw Failure(_translateDioError(e));
    } catch (_) {
      throw Failure('Não foi possível carregar o perfil');
    }
  }

  @override
  Future<void> logout() async {
    // Sessão é mantida apenas em memória pelo SessionViewModel.
  }

  String _translateDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Falha de conexão';
    }
    final status = e.response?.statusCode;
    if (status == 400 || status == 401) {
      return 'Usuário ou senha inválidos';
    }
    return 'Não foi possível fazer login';
  }
}
