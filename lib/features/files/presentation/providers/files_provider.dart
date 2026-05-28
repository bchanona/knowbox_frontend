import 'package:flutter/foundation.dart';
import 'package:knowbox/core/errors/failures.dart';
import 'package:knowbox/features/files/domain/entities/file_entity.dart';
import 'package:knowbox/features/files/domain/usecases/create_file_usecase.dart';
import 'package:knowbox/features/files/domain/usecases/delete_file_usecase.dart';
import 'package:knowbox/features/files/domain/usecases/get_files_usecase.dart';
import 'package:knowbox/features/files/domain/usecases/update_file_usecase.dart';

enum FilesStatus { initial, loading, success, error }

class FilesState {
  final FilesStatus status;
  final String? errorMessage;
  final List<FileEntity> files;

  const FilesState({
    this.status = FilesStatus.initial,
    this.errorMessage,
    this.files = const [],
  });

  FilesState copyWith({
    FilesStatus? status,
    String? errorMessage,
    List<FileEntity>? files,
  }) {
    return FilesState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      files: files ?? this.files,
    );
  }
}

class FilesProvider extends ChangeNotifier {
  final GetFilesUseCase _getFilesUseCase;
  final CreateFileUseCase _createFileUseCase;
  final UpdateFileUseCase _updateFileUseCase;
  final DeleteFileUseCase _deleteFileUseCase;

  FilesState _state = const FilesState();
  FilesState get state => _state;

  FilesProvider({
    required GetFilesUseCase getFilesUseCase,
    required CreateFileUseCase createFileUseCase,
    required UpdateFileUseCase updateFileUseCase,
    required DeleteFileUseCase deleteFileUseCase,
  })  : _getFilesUseCase = getFilesUseCase,
        _createFileUseCase = createFileUseCase,
        _updateFileUseCase = updateFileUseCase,
        _deleteFileUseCase = deleteFileUseCase;

  Future<void> loadFiles(int userId) async {
    _state = _state.copyWith(status: FilesStatus.loading, errorMessage: null);
    notifyListeners();

    try {
      final files = await _getFilesUseCase.call(userId);
      _state = _state.copyWith(status: FilesStatus.success, files: files);
    } on Failure catch (e) {
      _state = _state.copyWith(status: FilesStatus.error, errorMessage: e.message);
    } catch (e) {
      _state = _state.copyWith(status: FilesStatus.error, errorMessage: e.toString());
    }

    notifyListeners();
  }

  Future<void> createFile({
    required String title,
    String? description,
    required String url,
    required int userId,
  }) async {
    _state = _state.copyWith(status: FilesStatus.loading, errorMessage: null);
    notifyListeners();

    try {
      await _createFileUseCase.call(
        title: title,
        description: description,
        url: url,
        userId: userId,
      );
      await loadFiles(userId);
    } on Failure catch (e) {
      _state = _state.copyWith(status: FilesStatus.error, errorMessage: e.message);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(status: FilesStatus.error, errorMessage: e.toString());
      notifyListeners();
    }
  }

  Future<void> updateFile({
    required int id,
    String? title,
    String? description,
    String? url,
    required int userId,
  }) async {
    _state = _state.copyWith(status: FilesStatus.loading, errorMessage: null);
    notifyListeners();

    try {
      await _updateFileUseCase.call(
        id: id,
        title: title,
        description: description,
        url: url,
      );
      await loadFiles(userId);
    } on Failure catch (e) {
      _state = _state.copyWith(status: FilesStatus.error, errorMessage: e.message);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(status: FilesStatus.error, errorMessage: e.toString());
      notifyListeners();
    }
  }

  Future<void> deleteFile(int id, int userId) async {
    _state = _state.copyWith(status: FilesStatus.loading, errorMessage: null);
    notifyListeners();

    try {
      await _deleteFileUseCase.call(id);
      await loadFiles(userId);
    } on Failure catch (e) {
      _state = _state.copyWith(status: FilesStatus.error, errorMessage: e.message);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(status: FilesStatus.error, errorMessage: e.toString());
      notifyListeners();
    }
  }

  void resetState() {
    _state = const FilesState();
    notifyListeners();
  }
}
