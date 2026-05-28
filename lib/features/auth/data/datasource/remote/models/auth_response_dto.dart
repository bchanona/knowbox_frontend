import 'package:knowbox/features/auth/data/datasource/remote/models/user_dto.dart';
import 'package:knowbox/features/auth/domain/entities/auth_result.dart';

class AuthResponseDto {
  final UserDto user;
  final String token;

  const AuthResponseDto({required this.user, required this.token});

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  AuthResult toAuthResult() {
    return AuthResult(
      user: user.toEntity(),
      token: token,
    );
  }
}
