class Image {
  String? id;
  List<String>? exposedPorts = [];
  List<String>? repoTags = [];
  DateTime? createdAt;

  Image({this.id, this.createdAt, this.exposedPorts, this.repoTags});

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
