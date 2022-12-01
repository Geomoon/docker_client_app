class ImageModel {
  String? id;
  List<String>? exposedPorts = [];
  List<String>? repoTags = [];
  DateTime? createdAt;

  ImageModel({this.id, this.createdAt, this.exposedPorts, this.repoTags});

  ImageModel.fromJson(Map json)
      : id = json['Id'],
        repoTags = toStringList(json['RepoTags']),
        exposedPorts = mapToStringList(json['ContainerConfig']['ExposedPorts']),
        createdAt = DateTime.tryParse(json['Created']);

  static List<String> toStringList(List<dynamic> list) =>
      list.map((e) => e.toString()).toList();

  static List<String>? mapToStringList(Map<String, dynamic>? map) {
    return map?.entries.map((e) => e.key).toList();
  }

  @override
  String toString() {
    return 'id: $id,\n'
        'exposedPorts: $exposedPorts,\n'
        'repoTags: $repoTags,\n'
        'createdAt: $createdAt\n';
  }
}
