import 'package:docker_client_app/domain/images/ports/input/image_dto.dart';
import 'package:docker_client_app/domain/mounts/ports/input/mount_dto.dart';
import 'package:docker_client_app/domain/networks/port/input/network_dto.dart';

class ContainerDTO {
  String? id;
  String? name;
  String? status;
  DateTime? createdAt;
  ImageDTO? image;
  List<MountDTO>? mounts;
  List<NetworkDTO>? networks;

  ContainerDTO({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.image,
    this.mounts,
    this.networks,
  });
}
