class ImageDTO {
  String? id;
  List<String>? exposedPorts = [];
  List<String>? repoTags = [];
  DateTime? createdAt;

  ImageDTO({
    this.id,
    this.exposedPorts,
    this.repoTags,
    this.createdAt,
  });

  @override
  String toString() {
    return '{\n'
        '\tid: $id,\n'
        '\texposedPorts: $exposedPorts,\n'
        '\trepoTags: $repoTags,\n'
        '\tcreatedAt: $createdAt\n'
        '}';
  }
}
