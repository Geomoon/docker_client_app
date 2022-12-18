import 'dart:convert';

import 'package:docker_client_app/datasource/mounts/bind_model.dart';
import 'package:docker_client_app/datasource/mounts/mounts_mapper.dart';
import 'package:docker_client_app/datasource/mounts/volume_model.dart';
import 'package:docker_client_app/datasource/shared/shell.dart';
import 'package:docker_client_app/domain/mounts/mount.dart';
import 'package:docker_client_app/domain/mounts/ports/output/mounts_output_ports.dart';
import 'package:docker_client_app/domain/mounts/volume.dart';

class MountsOutputAdapter implements MountsOutputPort {
  final Shell _shell;
  final MountMapper _mapper;

  MountsOutputAdapter()
      : _shell = Shell(),
        _mapper = MountMapper();

  @override
  Future<List<Volume>> findAll() async {
    var ids = await _shell.run(
      'docker',
      ['volume', 'ls', '-q'],
    );

    List<String> idsList = ids.split('\n');

    var jsonString = await _shell.run(
      'docker',
      ['volume', 'inspect', ...idsList],
    );

    List decodec = json.decode(jsonString);

    List<VolumeModel> listModel =
        decodec.map((e) => VolumeModel.fromJson(e)).toList();

    return listModel.map((e) => _mapper.toDomainVolume(e)).toList();
  }

  @override
  Future<List<Mount>> findByContainer(String containerId) async {
    var jsonString = await _shell.run(
      'docker',
      ['container', 'inspect', containerId],
    );

    List list = json.decode(jsonString);
    if (list.isEmpty) return [];

    List mounts = list[0]['Mounts'];
    if (mounts.isEmpty) return [];

    List binds =
        mounts.takeWhile((element) => element['Type'] == 'bind').toList();

    mounts.removeWhere((element) => element['Type'] == 'bind');

    List domainVols = [];
    List domainBinds = [];
    if (mounts.isNotEmpty) {
      List<String> volsIds = mounts.map<String>((e) => e['Name']).toList();

      var volsString = await _shell.run(
        'docker',
        ['volume', 'inspect', ...volsIds],
      );

      List decodedVols = json.decode(volsString);

      List<VolumeModel> listModel =
          decodedVols.map((e) => VolumeModel.fromJson(e)).toList();
      domainVols = listModel.map((e) => _mapper.toDomainVolume(e)).toList();
    }

    if (binds.isNotEmpty) {
      List<BindModel> bindModels =
          binds.map((e) => BindModel.fromJson(e)).toList();
      domainBinds = bindModels.map((e) => _mapper.toDomainBind(e)).toList();
    }

    return [...domainVols, ...domainBinds];
  }

  @override
  Future<Volume?> findVolumeById(String id) async {
    var model = await _findVolModelById(id);
    if (model == null) return null;
    return _mapper.toDomainVolume(model);
  }

  Future<VolumeModel?> _findVolModelById(String id) async {
    var jsonString = await _shell.run(
      'docker',
      ['volume', 'inspect', id],
    );

    List decoded = json.decode(jsonString);
    if (decoded.isEmpty) return null;

    return VolumeModel.fromJson(decoded[0]);
  }

  @override
  Future<String> findVolumeSchemeById(String id) async {
    return await _shell.run('docker', ['volume', 'inspect', id]);
  }

  @override
  Future<List<Volume>> findVolumesByRegexID(String id) async {
    var idsString = await _shell.run(
        'docker', ['volume', 'ls', '-f=name=$id*', '--format', '{{.Name}}']);

    List<String> idsList = idsString.split('\n');

    var jsonString =
        await _shell.run('docker', ['volume', 'inspect', ...idsList]);

    List decodec = json.decode(jsonString);

    List<VolumeModel> listModel =
        decodec.map((e) => VolumeModel.fromJson(e)).toList();

    return listModel.map((e) => _mapper.toDomainVolume(e)).toList();
  }
}
