import 'package:docker_client_app/domain/containers/ports/input/container_dto.dart';
import 'package:docker_client_app/domain/containers/ports/input/container_mapper.dart';
import 'package:docker_client_app/domain/containers/ports/input/containers_input_port.dart';
import 'package:docker_client_app/domain/containers/ports/output/containers_output_port.dart';

class ContainersInteractor implements ContainersInputPort {
  final ContainersOutputPort _outputPort;
  final ContainersMapper _mapper = ContainersMapper();

  ContainersInteractor(this._outputPort);

  @override
  Future<List<ContainerDTO>> getAll() async {
    List list = await _outputPort.findAll();
    return list.map((e) => _mapper.toDTO(e)).toList();
  }

  @override
  Future<ContainerDTO?> getById(String id) async {
    var found = await _outputPort.findById(id);
    if (found != null) return _mapper.toDTO(found);

    throw Exception("[NOT FOUND]: Container id: $id");
  }

  @override
  Future<List<ContainerDTO>> getByImage(String imageId) async {
    List list = await _outputPort.findByImage(imageId);
    return list.map((e) => _mapper.toDTO(e)).toList();
  }

  @override
  Future<List<ContainerDTO>> getByName(String name) async {
    List list = await _outputPort.findByName(name);
    return list.map((e) => _mapper.toDTO(e)).toList();
  }

  @override
  Future<List<ContainerDTO>> getByNetwork(String networkId) async {
    List list = await _outputPort.findByNetwork(networkId);
    return list.map((e) => _mapper.toDTO(e)).toList();
  }

  @override
  Future<List<ContainerDTO>> getByStatus(String status) async {
    List list = await _outputPort.findByStatus(status);
    return list.map((e) => _mapper.toDTO(e)).toList();
  }
}
