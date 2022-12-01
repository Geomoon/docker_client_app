class ContainerModel {
  String? id;
  String? name;
  String? status;
  String? imageId;
  DateTime? createdAt;

  ContainerModel({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.imageId,
  });

  ContainerModel.fromJson(Map json)
      : id = json['Id'],
        name = json['Name'],
        status = json['State']['Status'],
        createdAt = DateTime.tryParse(json['Created']),
        imageId = json['Image'];

  @override
  String toString() {
    return '{\n'
        '\tid: $id,\n'
        '\tname: $name,\n'
        '\tstatus: $status,\n'
        '\tcreatedAt: $createdAt\n'
        '}';
  }
}
