import 'package:knowbox/features/files/domain/entities/file_entity.dart';
import 'package:knowbox/features/files/domain/repositories/files_repository.dart';

class GetFilesUseCase {
  final FilesRepository _repository;

  GetFilesUseCase(this._repository);

  Future<List<FileEntity>> call(int userId) async {
    return await _repository.getFilesByUser(userId);
  }
}
