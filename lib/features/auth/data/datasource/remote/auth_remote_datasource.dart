import 'package:knowbox/core/network/http_client.dart';
import 'package:knowbox/features/auth/data/datasource/remote/models/auth_response_dto.dart';

class AuthRemoteDataSource {
  final HttpClient _httpClient;

  AuthRemoteDataSource(this._httpClient);

  Future<AuthResponseDto> login({
    required String email,
    required String password,
  }) async {
    final response = await _httpClient.post(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    return AuthResponseDto.fromJson(response);
  }

  Future<AuthResponseDto> register({
    required String email,
    required String password,
    required String fullname,
  }) async {
    final response = await _httpClient.post(
      '/auth/register',
      body: {'email': email, 'password': password, 'fullname': fullname},
    );
    return AuthResponseDto.fromJson(response);
  }
}
