import 'package:knowbox/features/files/domain/entities/file_entity.dart';
import 'package:knowbox/features/files/domain/repositories/files_repository.dart';

class CreateFileUseCase {
  final FilesRepository _repository;

  CreateFileUseCase(this._repository);

  Future<FileEntity> call({
    required String title,
    String? description,
    required String url,
    required int userId,
  }) async {
    return await _repository.createFile(
      title: title,
      description: description,
      url: url,
      userId: userId,
    );
  }
}
