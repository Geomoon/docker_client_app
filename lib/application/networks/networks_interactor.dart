import 'package:docker_client_app/domain/networks/port/input/network_dto.dart';
import 'package:docker_client_app/domain/networks/port/input/networks_input_port.dart';
import 'package:docker_client_app/domain/networks/port/input/networks_mapper.dart';
import 'package:docker_client_app/domain/networks/port/output/networks_output_port.dart';

class NetworksInteractor implements NetworksInputPort {
  final NetworksOutputPort _outputPort;
  final NetworksMapper _mapper = NetworksMapper();

  NetworksInteractor(this._outputPort);

  @override
  Future<List<NetworkDTO>> getAll() async {
    List list = await _outputPort.findAll();
    return list.map((e) => _mapper.toDTO(e)).toList();
  }

  @override
  Future<List<NetworkDTO>> getByContainer(String containerId) async {
    List list = await _outputPort.findByContainer(containerId);
    return list.map((e) => _mapper.toDTO(e)).toList();
  }

  @override
  Future<NetworkDTO> getById(String id) async {
    var found = await _outputPort.findById(id);
    return _mapper.toDTO(found!);
  }

  @override
  Future<List<NetworkDTO>> getByName(String name) async {
    List list = await _outputPort.findByName(name);
    return list.map((e) => _mapper.toDTO(e)).toList();
  }
}
