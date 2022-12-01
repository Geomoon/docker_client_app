import 'dart:collection';
import 'dart:convert';

import 'package:docker_client_app/datasource/networks/network_model.dart';
import 'package:docker_client_app/datasource/networks/networks_mapper.dart';
import 'package:docker_client_app/datasource/shared/shell.dart';
import 'package:docker_client_app/domain/networks/network.dart';
import 'package:docker_client_app/domain/networks/port/output/networks_output_port.dart';

class NetworksOutputAdapter implements NetworksOutputPort {
  final Shell _shell;
  final NetworksMapper _mapper;

  NetworksOutputAdapter()
      : _shell = Shell(),
        _mapper = NetworksMapper();

  @override
  Future<List<Network>> findAll() async {
    var ids = await _shell.run(
      'docker',
      ['network', 'ls', '-q'],
    );

    List<String> idsList = ids.split('\n');

    var jsonString = await _shell.run(
      'docker',
      ['network', 'inspect', ...idsList],
    );

    List decoded = json.decode(jsonString);
    List<NetworkModel> modelList =
        decoded.map((e) => NetworkModel.fromJson(e)).toList();

    return modelList.map((e) => _mapper.toDomain(e)).toList();
  }

  @override
  Future<List<Network>> findByContainer(String containerId) async {
    var containerString = await _shell.run(
      'docker',
      ['container', 'inspect', containerId],
    );
    if (containerString == '[]\n') return [];

    List decoded = json.decode(containerString);
    var networks = decoded[0]['NetworkSettings']['Networks'] as Map;

    if (networks.isEmpty) return [];

    var networkIds = networks.keys.toList();

    var jsonString = await _shell.run(
      'docker',
      ['network', 'inspect', ...networkIds],
    );

    List decodedNetworks = json.decode(jsonString);
    List<NetworkModel> models =
        decodedNetworks.map((e) => NetworkModel.fromJson(e)).toList();

    return models.map((e) => _mapper.toDomain(e)).toList();
  }

  @override
  Future<Network?> findById(String id) async {
    var jsonString = await _shell.run(
      'docker',
      ['network', 'inspect', id],
    );

    List decoded = json.decode(jsonString);

    if (decoded.isEmpty) return null;
    NetworkModel model = NetworkModel.fromJson(decoded[0]);

    return _mapper.toDomain(model);
  }

  @override
  Future<List<Network>> findByName(String name) async {
    var ids = await _shell.run(
      'docker',
      ['network', 'ls', '--filter', 'name=$name*', '-q'],
    );

    if (ids.isEmpty) return [];

    List<String> idsList = ids.split('\n');

    var jsonString = await _shell.run(
      'docker',
      ['network', 'inspect', ...idsList],
    );

    List decoded = json.decode(jsonString);
    List<NetworkModel> modelList =
        decoded.map((e) => NetworkModel.fromJson(e)).toList();

    return modelList.map((e) => _mapper.toDomain(e)).toList();
  }
}

void main(List<String> args) async {
  var port = NetworksOutputAdapter();
  var res = await port.findByContainer('mysql_db');
  print(res);
}
