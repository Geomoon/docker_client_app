import 'dart:convert';

import 'package:docker_client_app/datasource/containers/container_mapper.dart';
import 'package:docker_client_app/datasource/containers/container_model.dart';
import 'package:docker_client_app/datasource/shared/shell.dart';
import 'package:docker_client_app/domain/containers/container.dart';
import 'package:docker_client_app/domain/containers/ports/output/containers_output_port.dart';
import 'package:docker_client_app/domain/images/ports/output/images_output_port.dart';
import 'package:docker_client_app/domain/mounts/ports/output/mounts_output_ports.dart';
import 'package:docker_client_app/domain/networks/port/output/networks_output_port.dart';

class ContainerOutputAdapter implements ContainersOutputPort {
  final Shell _shell;
  final ContainersMapper _mapper;

  final ImagesOutputPort _imagesOutputPort;
  final MountsOutputPort _mountsOutputPort;
  final NetworksOutputPort _networksOutputPort;

  ContainerOutputAdapter(
    this._imagesOutputPort,
    this._mountsOutputPort,
    this._networksOutputPort,
  )   : _shell = Shell(),
        _mapper = ContainersMapper();

  @override
  Future<List<Container>> findAll() async {
    var ids = await _shell.run(
      'docker',
      ['container', 'ls', '-a', '-q'],
    );

    List<String> idsList = ids.split('\n');

    var jsonString = await _shell.run(
      'docker',
      ['container', 'inspect', ...idsList],
    );

    List decodedContainers = json.decode(jsonString);
    if (decodedContainers.isEmpty) return [];

    List<ContainerModel> models =
        decodedContainers.map((e) => ContainerModel.fromJson(e)).toList();
    List<Container> list = await _createDomainList(models);
    return list;
  }

  @override
  Future<Container?> findById(String id) async {
    var jsonString = await _shell.run(
      'docker',
      ['container', 'inspect', id],
    );

    List decoded = json.decode(jsonString);
    if (decoded.isEmpty) return null;

    ContainerModel model = ContainerModel.fromJson(decoded[0]);
    Container container = await _createContainer(model);
    return container;
  }

  @override
  Future<List<Container>> findByImage(String imageId) async {
    var ids = await _shell.run(
      'docker',
      ['container', 'ls', '-a', '-q', '-f', 'ancestor=$imageId'],
    );

    List idsList = ids.split('\n');
    var jsonString = await _shell.run('docker', ['inspect', ...idsList]);

    List decoded = json.decode(jsonString);

    List<ContainerModel> models =
        decoded.map((e) => ContainerModel.fromJson(e)).toList();

    List<Container> list = await _createDomainList(models);
    return list;
  }

  @override
  Future<List<Container>> findByName(String name) async {
    var ids = await _shell.run(
        'docker', ['container', 'ls', '-a', '-q', '--filter', 'name=$name*']);

    List idsList = ids.split('\n');
    var jsonString = await _shell.run('docker', ['inspect', ...idsList]);

    List decoded = json.decode(jsonString);

    List<ContainerModel> models =
        decoded.map((e) => ContainerModel.fromJson(e)).toList();

    List<Container> list = await _createDomainList(models);
    return list;
  }

  @override
  Future<List<Container>> findByNetwork(String networkId) async {
    var ids = await _shell.run(
        'docker', ['container', 'ls', '-a', '-q', '-f', 'network=$networkId']);

    List<String> idsList = ids.split('\n');

    var jsonString =
        await _shell.run('docker', ['container', 'inspect', ...idsList]);

    if (jsonString == '[]') return [];

    List decoded = json.decode(jsonString);
    List<ContainerModel> models =
        decoded.map((e) => ContainerModel.fromJson(e)).toList();
    List<Container> list = await _createDomainList(models);
    return list;
  }

  @override
  Future<List<Container>> findByStatus(String status) async {
    var ids = await _shell
        .run('docker', ['container', 'ls', '-a', '-q', '-f', 'status=$status']);

    List<String> idsList = ids.split('\n');
    if (idsList.isEmpty) return [];

    var jsonString =
        await _shell.run('docker', ['container', 'inspect', ...idsList]);

    if (jsonString == '') return [];

    List decoded = json.decode(jsonString);
    List<ContainerModel> models =
        decoded.map((e) => ContainerModel.fromJson(e)).toList();
    List<Container> list = await _createDomainList(models);
    return list;
  }

  Future<List<Container>> _createDomainList(List<ContainerModel> models) async {
    List<Container> list = [];
    for (ContainerModel element in models) {
      var container = await _createContainer(element);
      list.add(container);
    }
    return list;
  }

  Future<Container> _createContainer(ContainerModel model) async {
    Container c = _mapper.toDomain(model);
    var image = await _imagesOutputPort.findById(model.imageId!);
    var mounts = await _mountsOutputPort.findByContainer(model.id!);
    var networks = await _networksOutputPort.findByContainer(model.id!);
    c.image = image;
    c.mounts = mounts;
    c.networks = networks;
    return c;
  }
}
