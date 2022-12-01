import 'package:docker_client_app/domain/mounts/ports/input/mount_dto.dart';
import 'package:docker_client_app/domain/mounts/ports/input/volume_dto.dart';

abstract class MountsInputPort {
  Future<List<VolumeDTO>> getAllVolumes();
  Future<VolumeDTO> getVolumeById(String id);
  Future<List<MountDTO>> getByContainer(String containerId);
}
