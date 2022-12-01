import 'package:docker_client_app/domain/mounts/bind.dart';
import 'package:docker_client_app/domain/mounts/mount.dart';
import 'package:docker_client_app/domain/mounts/mount_type.dart';
import 'package:docker_client_app/domain/mounts/ports/input/bind_dto.dart';
import 'package:docker_client_app/domain/mounts/ports/input/mount_dto.dart';
import 'package:docker_client_app/domain/mounts/ports/input/volume_dto.dart';
import 'package:docker_client_app/domain/mounts/volume.dart';

class MountsMapper {
  VolumeDTO toVolumeDTO(Volume volume) => VolumeDTO(
        name: volume.name,
        createdAt: volume.createdAt,
        driver: volume.driver,
        mountpoint: volume.mountpoint,
        scope: volume.scope,
      );

  BindDTO toBindDTO(Bind bind) => BindDTO(
        destination: bind.destination,
        rw: bind.rw,
        source: bind.source,
      );

  MountDTO toDTO(Mount mount) {
    if (mount.runtimeType.toString() == MountType.bind.toString()) {
      return toBindDTO(mount as Bind);
    }

    if (mount.runtimeType.toString() == MountType.volume.toString()) {
      return toVolumeDTO(mount as Volume);
    }
    throw Exception("Error map");
  }
}
