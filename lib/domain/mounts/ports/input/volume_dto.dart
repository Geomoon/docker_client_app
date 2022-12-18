import 'package:docker_client_app/domain/mounts/ports/input/mount_dto.dart';

class VolumeDTO implements MountDTO {
  String? name;
  String? driver;
  String? mountpoint;
  String? scope;
  DateTime? createdAt;

  VolumeDTO({
    this.name,
    this.driver,
    this.mountpoint,
    this.scope,
    this.createdAt,
  });

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
