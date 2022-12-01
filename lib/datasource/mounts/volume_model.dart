class VolumeModel {
  String? name;
  String? driver;
  String? mountpoint;
  String? scope;
  DateTime? createdAt;

  VolumeModel({
    this.name,
    this.driver,
    this.mountpoint,
    this.scope,
    this.createdAt,
  });

  VolumeModel.fromJson(Map json)
      : name = json['Name'],
        driver = json['Driver'],
        scope = json['Scope'],
        mountpoint = json['Mountpoint'],
        createdAt = DateTime.tryParse(json['CreatedAt']);

  @override
  String toString() {
    return '{\n'
        '\tname: $name,\n'
        '\tdriver: $driver,\n'
        '\tscope: $scope,\n'
        '\tmountpoint: $mountpoint,\n'
        '\tcreatedAt: $createdAt\n'
        '}';
  }
}
