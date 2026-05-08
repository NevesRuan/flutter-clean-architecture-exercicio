import 'package:flutter/foundation.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class SessionViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthUser? _user;
  bool _isLoading = false;
  String? _error;

  SessionViewModel(this.repository);

  AuthUser? get user => _user;
  bool get isLoggedIn => _user != null;
  String? get token => _user?.accessToken;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> signIn(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await repository.login(
        username: username,
        password: password,
      );
    } on Failure catch (f) {
      _error = f.message;
      _user = null;
    } catch (_) {
      _error = 'Erro inesperado ao fazer login';
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchCurrentUser() {
    final t = token;
    if (t == null) {
      throw Failure('Sessão expirada');
    }
    return repository.getCurrentUser(t);
  }

  void signOut() {
    _user = null;
    _error = null;
    repository.logout();
    notifyListeners();
  }
}
