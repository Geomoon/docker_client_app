import 'package:docker_client_app/domain/mounts/mount.dart';

class Volume implements Mount {
  String? name;
  String? driver;
  String? mountpoint;
  String? scope;
  DateTime? createdAt;

  Volume({this.name, this.driver, this.mountpoint, this.scope, this.createdAt});

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
