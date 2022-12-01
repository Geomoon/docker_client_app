import 'package:docker_client_app/domain/images/ports/input/image_dto.dart';
import 'package:docker_client_app/domain/images/ports/input/images_input_port.dart';
import 'package:docker_client_app/domain/images/ports/input/images_mapper.dart';
import 'package:docker_client_app/domain/images/ports/output/images_output_port.dart';

class ImagesInteractor implements ImagesInputPort {
  final ImagesOutputPort _outputPort;
  final ImagesMapper _mapper = ImagesMapper();

  ImagesInteractor(this._outputPort);

  @override
  Future<List<ImageDTO>> getAll() async {
    List list = await _outputPort.findAll();
    return list.map((e) => _mapper.toDTO(e)).toList();
  }

  @override
  Future<ImageDTO> getById(String id) async {
    var found = await _outputPort.findById(id);
    if (found == null) throw Exception('[NOT FOUND]: Image id: $id');
    return _mapper.toDTO(found);
  }

  @override
  Future<List<ImageDTO>> getByRepository(String repo) async {
    List list = await _outputPort.findByRepository(repo);
    return list.map((e) => _mapper.toDTO(e)).toList();
  }
}
