import 'package:docker_client_app/domain/mounts/mount.dart';
import 'package:docker_client_app/domain/mounts/volume.dart';

abstract class MountsOutputPort {
  Future<List<Volume>> findAll();
  Future<Volume?> findVolumeById(String id);
  Future<List<Mount>> findByContainer(String containerId);
}
