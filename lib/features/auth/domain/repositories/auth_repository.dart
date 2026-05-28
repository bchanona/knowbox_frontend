import 'package:knowbox/features/auth/domain/entities/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login({required String email, required String password});
  Future<AuthResult> register({
    required String email,
    required String password,
    required String fullname,
  });
}
