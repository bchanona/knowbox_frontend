import 'package:knowbox/features/files/domain/entities/file_entity.dart';

abstract class FilesRepository {
  Future<List<FileEntity>> getFilesByUser(int userId);
  Future<FileEntity> createFile({
    required String title,
    String? description,
    required String url,
    required int userId,
  });
  Future<FileEntity> updateFile({
    required int id,
    String? title,
    String? description,
    String? url,
  });
  Future<void> deleteFile(int id);
}
