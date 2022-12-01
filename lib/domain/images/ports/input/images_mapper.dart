import 'package:docker_client_app/domain/images/image.dart';
import 'package:docker_client_app/domain/images/ports/input/image_dto.dart';

class ImagesMapper {
  ImageDTO toDTO(Image image) => ImageDTO(
        id: image.id,
        createdAt: image.createdAt,
        exposedPorts: image.exposedPorts,
        repoTags: image.repoTags,
      );
}
