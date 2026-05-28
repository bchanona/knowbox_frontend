import 'package:knowbox/features/files/domain/repositories/files_repository.dart';

class DeleteFileUseCase {
  final FilesRepository _repository;

  DeleteFileUseCase(this._repository);

  Future<void> call(int id) async {
    return await _repository.deleteFile(id);
  }
}
