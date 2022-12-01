import 'package:docker_client_app/datasource/networks/network_model.dart';
import 'package:docker_client_app/domain/networks/network.dart';

class NetworksMapper {
  Network toDomain(NetworkModel model) => Network(
        id: model.id,
        createdAt: model.createdAt,
        driver: model.driver,
        gateway: model.gateway,
        name: model.name,
        scope: model.scope,
        subnet: model.subnet,
      );
}
