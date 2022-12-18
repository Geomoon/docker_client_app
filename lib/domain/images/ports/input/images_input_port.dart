import 'package:docker_client_app/domain/images/ports/input/image_dto.dart';

abstract class ImagesInputPort {
  Future<List<ImageDTO>> getAll();
  Future<ImageDTO> getById(String id);
  Future<List<ImageDTO>> getByRepository(String repo);
  Future<String> getSchemeById(String id);
  Future deleteById(String id);
}
