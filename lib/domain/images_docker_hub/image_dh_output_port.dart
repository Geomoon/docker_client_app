import 'package:docker_client_app/domain/images_docker_hub/image_docker_hub.dart';

abstract class ImageDHOutputPort {
  Future<List<ImageDH>> findByName(String name);
  Future pullImage(String name);
}
