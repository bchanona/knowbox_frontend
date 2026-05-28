import 'package:knowbox/core/di/app_container.dart';
import 'package:knowbox/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:knowbox/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:knowbox/features/auth/domain/repositories/auth_repository.dart';
import 'package:knowbox/features/auth/domain/usecases/login_usecase.dart';
import 'package:knowbox/features/auth/domain/usecases/register_usecase.dart';
import 'package:knowbox/features/auth/presentation/providers/auth_provider.dart';

class AuthDI {
  final AppContainer appContainer;

  late final AuthRemoteDataSource authRemoteDataSource;
  late final AuthRepository authRepository;
  late final LoginUseCase loginUseCase;
  late final RegisterUseCase registerUseCase;
  late final AuthProvider authProvider;

  AuthDI(this.appContainer) {
    _init();
  }

  void _init() {
    authRemoteDataSource = AuthRemoteDataSource(appContainer.httpClient);
    authRepository = AuthRepositoryImpl(authRemoteDataSource);
    loginUseCase = LoginUseCase(authRepository);
    registerUseCase = RegisterUseCase(authRepository);
    authProvider = AuthProvider(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      tokenStorage: appContainer.tokenStorage,
      onTokenChanged: appContainer.httpClient.setToken,
    );
  }
}
