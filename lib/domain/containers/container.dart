import 'package:docker_client_app/domain/images/image.dart';
import 'package:docker_client_app/domain/mounts/mount.dart';
import 'package:docker_client_app/domain/networks/network.dart';

class Container {
  String? id;
  String? name;
  String? status;
  DateTime? createdAt;
  Image? image;
  List<Mount>? mounts;
  List<Network>? networks;

  Container({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.image,
    this.mounts,
    this.networks,
  });
}
