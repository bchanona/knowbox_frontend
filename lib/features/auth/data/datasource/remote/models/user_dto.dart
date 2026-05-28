import 'package:knowbox/features/auth/domain/entities/user_entity.dart';

class UserDto {
  final String id;
  final String email;
  final String fullname;

  const UserDto({
    required this.id,
    required this.email,
    required this.fullname,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'].toString(),
      email: json['email'] as String,
      fullname: json['fullname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullname': fullname,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullname: fullname,
    );
  }
}
