import 'package:docker_client_app/domain/mounts/mount.dart';
import 'package:docker_client_app/domain/mounts/volume.dart';

abstract class MountsOutputPort {
  Future<List<Volume>> findAll();
  Future<Volume?> findVolumeById(String id);
  Future<List<Mount>> findByContainer(String containerId);
  Future<String> findVolumeSchemeById(String id);
  Future<List<Volume>> findVolumesByRegexID(String id);
}
