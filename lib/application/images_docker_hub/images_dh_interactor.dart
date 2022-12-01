import 'package:docker_client_app/domain/images_docker_hub/image_dh_output_port.dart';
import 'package:docker_client_app/domain/images_docker_hub/image_docker_hub.dart';
import 'package:docker_client_app/domain/images_docker_hub/images_dh_input_port.dart';

class ImagesDHInteractor implements ImagesDHInputPort {
  final ImageDHOutputPort _dhOutputPort;

  ImagesDHInteractor(this._dhOutputPort);

  @override
  Future<List<ImageDH>> findByName(String name) {
    return _dhOutputPort.findByName(name);
  }
}
