import 'package:docker_client_app/domain/networks/port/input/network_dto.dart';

abstract class NetworksInputPort {
  Future<List<NetworkDTO>> getAll();
  Future<NetworkDTO> getById(String id);
  Future<List<NetworkDTO>> getByName(String name);
  Future<List<NetworkDTO>> getByContainer(String containerId);
}
