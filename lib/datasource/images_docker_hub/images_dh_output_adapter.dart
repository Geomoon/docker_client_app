import 'dart:convert';

import 'package:docker_client_app/datasource/shared/shell.dart';
import 'package:http/http.dart' as http;

import 'package:docker_client_app/domain/images_docker_hub/image_dh_output_port.dart';
import 'package:docker_client_app/domain/images_docker_hub/image_docker_hub.dart';

class ImagesDHOutputAdapter implements ImageDHOutputPort {
  ImagesDHOutputAdapter() : _shell = Shell();

  final Shell _shell;

  @override
  Future<List<ImageDH>> findByName(String name) async {
    if (name.isEmpty) return [];

    final url = 'https://index.docker.io/v1/search?q=$name&n=12';
    final res = await http.get(Uri.parse(url));
    final body = jsonDecode(res.body);
    List list = body['results'];
    return list.map((e) => ImageDH.fromJson(e)).toList();
  }

  @override
  Future pullImage(String name) async {
    if (name.isEmpty) return false;
    var res = await _shell.run('docker', ['pull', name]);
    List list = res.split('\n');
    final String resp = list[list.length - 3];
    return resp.contains('Downloaded');
  }
}
