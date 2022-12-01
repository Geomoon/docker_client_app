import 'package:docker_client_app/domain/networks/network.dart';
import 'package:docker_client_app/domain/networks/port/input/network_dto.dart';

class NetworksMapper {
  NetworkDTO toDTO(Network network) => NetworkDTO(
        id: network.id,
        createdAt: network.createdAt,
        driver: network.driver,
        gateway: network.gateway,
        name: network.name,
        scope: network.scope,
        subnet: network.subnet,
      );
}
