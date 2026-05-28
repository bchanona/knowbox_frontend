class FileEntity {
  final int id;
  final String title;
  final String? description;
  final String url;
  final int idUser;

  const FileEntity({
    required this.id,
    required this.title,
    this.description,
    required this.url,
    required this.idUser,
  });
}
