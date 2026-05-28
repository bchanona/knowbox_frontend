import 'package:knowbox/features/files/domain/entities/file_entity.dart';
import 'package:knowbox/features/files/domain/repositories/files_repository.dart';

class UpdateFileUseCase {
  final FilesRepository _repository;

  UpdateFileUseCase(this._repository);

  Future<FileEntity> call({
    required int id,
    String? title,
    String? description,
    String? url,
  }) async {
    return await _repository.updateFile(
      id: id,
      title: title,
      description: description,
      url: url,
    );
  }
}
