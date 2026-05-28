import 'package:knowbox/core/errors/failures.dart';
import 'package:knowbox/core/network/http_client.dart';
import 'package:knowbox/features/files/data/datasource/remote/files_remote_datasource.dart';
import 'package:knowbox/features/files/domain/entities/file_entity.dart';
import 'package:knowbox/features/files/domain/repositories/files_repository.dart';

class FilesRepositoryImpl implements FilesRepository {
  final FilesRemoteDataSource _dataSource;

  FilesRepositoryImpl(this._dataSource);

  @override
  Future<List<FileEntity>> getFilesByUser(int userId) async {
    try {
      final files = await _dataSource.getFilesByUser(userId);
      return files.map((f) => f.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<FileEntity> createFile({
    required String title,
    String? description,
    required String url,
    required int userId,
  }) async {
    try {
      final file = await _dataSource.createFile(
        title: title,
        description: description,
        url: url,
        userId: userId,
      );
      return file.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<FileEntity> updateFile({
    required int id,
    String? title,
    String? description,
    String? url,
  }) async {
    try {
      final file = await _dataSource.updateFile(
        id: id,
        title: title,
        description: description,
        url: url,
      );
      return file.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> deleteFile(int id) async {
    try {
      await _dataSource.deleteFile(id);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
