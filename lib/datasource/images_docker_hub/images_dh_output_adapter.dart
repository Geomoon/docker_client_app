import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:docker_client_app/domain/images_docker_hub/image_dh_output_port.dart';
import 'package:docker_client_app/domain/images_docker_hub/image_docker_hub.dart';

class ImagesDHOutputAdapter implements ImageDHOutputPort {
  ImagesDHOutputAdapter();

  @override
  Future<List<ImageDH>> findByName(String name) async {
    final url = 'https://index.docker.io/v1/search?q=$name&n=2';
    final res = await http.get(Uri.parse(url));
    final body = jsonDecode(res.body);
    List list = body['results'];
    return list.map((e) => ImageDH.fromJson(e)).toList();
  }
}
