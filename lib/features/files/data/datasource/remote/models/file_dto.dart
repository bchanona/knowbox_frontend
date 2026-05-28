import 'package:knowbox/features/files/domain/entities/file_entity.dart';

class FileDto {
  final int id;
  final String title;
  final String? description;
  final String url;
  final int idUser;

  const FileDto({
    required this.id,
    required this.title,
    this.description,
    required this.url,
    required this.idUser,
  });

  factory FileDto.fromJson(Map<String, dynamic> json) {
    return FileDto(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      url: json['url'] as String,
      idUser: json['id_user'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'id_user': idUser,
    };
  }

  FileEntity toEntity() {
    return FileEntity(
      id: id,
      title: title,
      description: description,
      url: url,
      idUser: idUser,
    );
  }
}
