import 'package:docker_client_app/datasource/mounts/bind_model.dart';
import 'package:docker_client_app/datasource/mounts/volume_model.dart';
import 'package:docker_client_app/domain/mounts/bind.dart';
import 'package:docker_client_app/domain/mounts/volume.dart';

class MountMapper {
  Volume toDomainVolume(VolumeModel model) => Volume(
        name: model.name,
        createdAt: model.createdAt,
        driver: model.driver,
        mountpoint: model.mountpoint,
        scope: model.scope,
      );

  Bind toDomainBind(BindModel bind) => Bind(
        destination: bind.destination,
        rw: bind.rw,
        source: bind.source,
      );
}
