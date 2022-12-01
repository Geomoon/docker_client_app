import 'package:docker_client_app/domain/images_docker_hub/image_docker_hub.dart';

abstract class ImagesDHInputPort {
  Future<List<ImageDH>> findByName(String name);
}
