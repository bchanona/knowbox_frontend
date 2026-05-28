import 'package:flutter/foundation.dart';
import 'package:knowbox/core/errors/failures.dart';
import 'package:knowbox/core/storage/token_storage.dart';
import 'package:knowbox/features/auth/domain/entities/user_entity.dart';
import 'package:knowbox/features/auth/domain/usecases/login_usecase.dart';
import 'package:knowbox/features/auth/domain/usecases/register_usecase.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final UserEntity? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    UserEntity? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final TokenStorage _tokenStorage;
  final void Function(String?)? _onTokenChanged;

  AuthState _state = const AuthState();
  AuthState get state => _state;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required TokenStorage tokenStorage,
    void Function(String?)? onTokenChanged,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _tokenStorage = tokenStorage,
        _onTokenChanged = onTokenChanged;

  Future<void> initialize() async {
    final savedToken = await _tokenStorage.getToken();
    final savedUser = await _tokenStorage.getUserData();

    if (savedToken != null && savedUser != null) {
      _onTokenChanged?.call(savedToken);
      _state = _state.copyWith(
        status: AuthStatus.success,
        user: UserEntity(
          id: savedUser['id'] as String,
          email: savedUser['email'] as String,
          fullname: savedUser['fullname'] as String,
        ),
      );
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _state = _state.copyWith(status: AuthStatus.loading, errorMessage: null);
    notifyListeners();

    try {
      final result = await _loginUseCase.call(email: email, password: password);
      await _tokenStorage.saveToken(result.token);
      await _tokenStorage.saveUser(
        id: result.user.id,
        email: result.user.email,
        fullname: result.user.fullname,
      );
      _onTokenChanged?.call(result.token);
      _state = _state.copyWith(status: AuthStatus.success, user: result.user);
    } on Failure catch (e) {
      _state = _state.copyWith(status: AuthStatus.error, errorMessage: e.message);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }

    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullname,
  }) async {
    _state = _state.copyWith(status: AuthStatus.loading, errorMessage: null);
    notifyListeners();

    try {
      final result = await _registerUseCase.call(
        email: email,
        password: password,
        fullname: fullname,
      );
      await _tokenStorage.saveToken(result.token);
      await _tokenStorage.saveUser(
        id: result.user.id,
        email: result.user.email,
        fullname: result.user.fullname,
      );
      _onTokenChanged?.call(result.token);
      _state = _state.copyWith(status: AuthStatus.success, user: result.user);
    } on Failure catch (e) {
      _state = _state.copyWith(status: AuthStatus.error, errorMessage: e.message);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error, errorMessage: e.toString());
    }

    notifyListeners();
  }

  void resetState() {
    _tokenStorage.clearToken();
    _onTokenChanged?.call(null);
    _state = const AuthState();
    notifyListeners();
  }
}
