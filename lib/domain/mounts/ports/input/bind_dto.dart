import 'package:docker_client_app/domain/mounts/ports/input/mount_dto.dart';

class BindDTO implements MountDTO {
  String? source;
  String? destination;
  bool rw;

  BindDTO({this.source, this.destination, this.rw = true});
}
