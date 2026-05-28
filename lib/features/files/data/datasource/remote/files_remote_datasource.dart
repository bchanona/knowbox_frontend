import 'package:knowbox/core/network/http_client.dart';
import 'package:knowbox/features/files/data/datasource/remote/models/file_dto.dart';

class FilesRemoteDataSource {
  final HttpClient _httpClient;

  FilesRemoteDataSource(this._httpClient);

  Future<List<FileDto>> getFilesByUser(int userId) async {
    final list = await _httpClient.getList('/files/user/$userId');
    return list.map((e) => FileDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<FileDto> createFile({
    required String title,
    String? description,
    required String url,
    required int userId,
  }) async {
    final response = await _httpClient.post(
      '/files',
      body: {
        'title': title,
        if (description != null) 'description': description,
        'url': url,
        'id_user': userId,
      },
    );
    return FileDto.fromJson(response);
  }

  Future<FileDto> updateFile({
    required int id,
    String? title,
    String? description,
    String? url,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (url != null) body['url'] = url;

    final response = await _httpClient.put('/files/$id', body: body);
    return FileDto.fromJson(response);
  }

  Future<void> deleteFile(int id) async {
    await _httpClient.delete('/files/$id');
  }
}
