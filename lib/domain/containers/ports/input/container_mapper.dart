import 'package:docker_client_app/domain/containers/container.dart';
import 'package:docker_client_app/domain/containers/ports/input/container_dto.dart';
import 'package:docker_client_app/domain/images/ports/input/images_mapper.dart';
import 'package:docker_client_app/domain/mounts/ports/input/mounts_mapper.dart';
import 'package:docker_client_app/domain/networks/port/input/networks_mapper.dart';

class ContainersMapper {
  final _imageMapper = ImagesMapper();
  final _mountMapper = MountsMapper();
  final _networkMapper = NetworksMapper();

  ContainerDTO toDTO(Container container) {
    var imageDTO = _imageMapper.toDTO(container.image!);

    var mountsDTO =
        container.mounts?.map((e) => _mountMapper.toDTO(e)).toList();

    var networksDTO =
        container.networks?.map((e) => _networkMapper.toDTO(e)).toList();

    return ContainerDTO(
      id: container.id,
      createdAt: container.createdAt,
      name: container.name,
      status: container.status,
      image: imageDTO,
      mounts: mountsDTO,
      networks: networksDTO,
    );
  }
}
