import 'package:knowbox/core/di/app_container.dart';
import 'package:knowbox/features/files/data/datasource/remote/files_remote_datasource.dart';
import 'package:knowbox/features/files/data/repositories_impl/files_repository_impl.dart';
import 'package:knowbox/features/files/domain/repositories/files_repository.dart';
import 'package:knowbox/features/files/domain/usecases/create_file_usecase.dart';
import 'package:knowbox/features/files/domain/usecases/delete_file_usecase.dart';
import 'package:knowbox/features/files/domain/usecases/get_files_usecase.dart';
import 'package:knowbox/features/files/domain/usecases/update_file_usecase.dart';
import 'package:knowbox/features/files/presentation/providers/files_provider.dart';

class FilesDI {
  final AppContainer appContainer;

  late final FilesRemoteDataSource filesRemoteDataSource;
  late final FilesRepository filesRepository;
  late final GetFilesUseCase getFilesUseCase;
  late final CreateFileUseCase createFileUseCase;
  late final UpdateFileUseCase updateFileUseCase;
  late final DeleteFileUseCase deleteFileUseCase;
  late final FilesProvider filesProvider;

  FilesDI(this.appContainer) {
    _init();
  }

  void _init() {
    filesRemoteDataSource = FilesRemoteDataSource(appContainer.httpClient);
    filesRepository = FilesRepositoryImpl(filesRemoteDataSource);
    getFilesUseCase = GetFilesUseCase(filesRepository);
    createFileUseCase = CreateFileUseCase(filesRepository);
    updateFileUseCase = UpdateFileUseCase(filesRepository);
    deleteFileUseCase = DeleteFileUseCase(filesRepository);
    filesProvider = FilesProvider(
      getFilesUseCase: getFilesUseCase,
      createFileUseCase: createFileUseCase,
      updateFileUseCase: updateFileUseCase,
      deleteFileUseCase: deleteFileUseCase,
    );
  }
}
