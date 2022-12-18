import 'package:docker_client_app/datasource/mounts/mounts_output_adapter.dart';
import 'package:docker_client_app/domain/mounts/ports/input/mount_dto.dart';
import 'package:docker_client_app/domain/mounts/ports/input/mounts_input_port.dart';
import 'package:docker_client_app/domain/mounts/ports/input/mounts_mapper.dart';
import 'package:docker_client_app/domain/mounts/ports/input/volume_dto.dart';
import 'package:docker_client_app/domain/mounts/ports/output/mounts_output_ports.dart';

class MountsInteractor implements MountsInputPort {
  final MountsOutputPort _outputPort;
  final MountsMapper _mapper = MountsMapper();

  MountsInteractor(this._outputPort);

  @override
  Future<List<VolumeDTO>> getAllVolumes() async {
    List list = await _outputPort.findAll();
    print('QUERYY');
    return list.map((e) => _mapper.toVolumeDTO(e)).toList();
  }

  @override
  Future<List<MountDTO>> getByContainer(String containerId) async {
    List list = await _outputPort.findByContainer(containerId);
    return list.map((e) => _mapper.toDTO(e)).toList();
  }

  @override
  Future<VolumeDTO> getVolumeById(String id) async {
    var found = await _outputPort.findVolumeById(id);
    if (found != null) return _mapper.toVolumeDTO(found);
    throw Exception("[NOT FOUND]: Image id: $id");
  }

  @override
  Future<String> getVolumeSchemeById(String id) async {
    return await _outputPort.findVolumeSchemeById(id);
  }

  @override
  Future<List<VolumeDTO>> getVolumesByRegexID(String id) async {
    List list = await _outputPort.findVolumesByRegexID(id);
    return list.map((e) => _mapper.toVolumeDTO(e)).toList();
  }
}
