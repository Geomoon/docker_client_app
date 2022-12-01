import 'package:docker_client_app/domain/mounts/bind.dart';
import 'package:docker_client_app/domain/mounts/mount.dart';
import 'package:docker_client_app/domain/mounts/mount_type.dart';
import 'package:docker_client_app/domain/mounts/volume.dart';

class MountFactory {
  Mount? create(MountType type) {
    if (type == MountType.bind) return Bind();
    if (type == MountType.volume) return Volume();
    throw Exception("Error MountFactory.create()");
  }
}
