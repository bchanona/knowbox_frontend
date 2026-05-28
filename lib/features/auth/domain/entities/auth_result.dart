import 'package:knowbox/features/auth/domain/entities/user_entity.dart';

class AuthResult {
  final UserEntity user;
  final String token;

  const AuthResult({required this.user, required this.token});
}
