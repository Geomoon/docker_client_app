import 'dart:convert';

import 'package:docker_client_app/datasource/images/image_model.dart';
import 'package:docker_client_app/datasource/images/images_mapper.dart';
import 'package:docker_client_app/datasource/shared/shell.dart';
import 'package:docker_client_app/domain/images/image.dart';
import 'package:docker_client_app/domain/images/ports/output/images_output_port.dart';

class ImagesOutputAdapter implements ImagesOutputPort {
  final Shell _shell;
  final ImagesMapper _mapper;

  ImagesOutputAdapter()
      : _shell = Shell(),
        _mapper = ImagesMapper();

  @override
  Future<List<Image>> findAll() async {
    var ids = await _shell.run('docker', ['image', 'ls', '-q']);
    List<String> idsList = ids.split('\n');

    var jsonString = await _shell.run(
      'docker',
      ['image', 'inspect', ...idsList],
    );

    List decoded = json.decode(jsonString);

    List<ImageModel> listModel =
        decoded.map((e) => ImageModel.fromJson(e)).toList();

    return listModel.map((e) => _mapper.toDomain(e)).toList();
  }

  @override
  Future<Image?> findById(String id) async {
    var jsonString = await _shell.run(
      'docker',
      ['image', 'inspect', id],
    );

    List decoded = json.decode(jsonString);

    if (decoded.isEmpty) return null;

    ImageModel model = ImageModel.fromJson(decoded[0]);
    return _mapper.toDomain(model);
  }

  @override
  Future<List<Image>> findByRepository(String repo) async {
    var ids = await _shell.run(
      'docker',
      ['image', 'ls', '--filter', 'reference=*$repo*', '-q'],
    );
    List<String> idsList = ids.split('\n');
    var jsonString = await _shell.run(
      'docker',
      ['image', 'inspect', ...idsList],
    );
    List decoded = json.decode(jsonString);

    List<ImageModel> listModel =
        decoded.map((e) => ImageModel.fromJson(e)).toList();

    return listModel.map((e) => _mapper.toDomain(e)).toList();
  }
}
