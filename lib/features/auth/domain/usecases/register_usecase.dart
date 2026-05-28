import 'package:knowbox/features/auth/domain/entities/auth_result.dart';
import 'package:knowbox/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<AuthResult> call({
    required String email,
    required String password,
    required String fullname,
  }) async {
    return await _repository.register(
      email: email,
      password: password,
      fullname: fullname,
    );
  }
}
