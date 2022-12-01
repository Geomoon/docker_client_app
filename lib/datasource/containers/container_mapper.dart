import 'package:docker_client_app/datasource/containers/container_model.dart';
import 'package:docker_client_app/domain/containers/container.dart';

class ContainersMapper {
  Container toDomain(ContainerModel model) {
    return Container(
      id: model.id,
      createdAt: model.createdAt,
      name: model.name,
      status: model.status,
    );
  }
}
