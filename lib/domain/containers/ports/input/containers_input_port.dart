import 'package:docker_client_app/domain/containers/ports/input/container_dto.dart';

abstract class ContainersInputPort {
  Future<List<ContainerDTO>> getAll();
  Future<ContainerDTO?> getById(String id);
  Future<List<ContainerDTO>> getByName(String name);
  Future<List<ContainerDTO>> getByImage(String imageId);
  Future<List<ContainerDTO>> getByStatus(String status);
  Future<List<ContainerDTO>> getByNetwork(String networkId);
}
