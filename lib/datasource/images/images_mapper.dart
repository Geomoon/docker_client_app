import 'package:docker_client_app/datasource/images/image_model.dart';
import 'package:docker_client_app/domain/images/image.dart';

class ImagesMapper {
  Image toDomain(ImageModel model) => Image(
        id: model.id,
        createdAt: model.createdAt,
        exposedPorts: model.exposedPorts,
        repoTags: model.repoTags,
      );
}
