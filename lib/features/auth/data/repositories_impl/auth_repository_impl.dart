import 'package:knowbox/core/errors/failures.dart';
import 'package:knowbox/core/network/http_client.dart';
import 'package:knowbox/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:knowbox/features/auth/domain/entities/auth_result.dart';
import 'package:knowbox/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dataSource.login(email: email, password: password);
      return response.toAuthResult();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<AuthResult> register({
    required String email,
    required String password,
    required String fullname,
  }) async {
    try {
      final response = await _dataSource.register(
        email: email,
        password: password,
        fullname: fullname,
      );
      return response.toAuthResult();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
