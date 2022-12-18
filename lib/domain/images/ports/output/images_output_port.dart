import 'package:docker_client_app/domain/images/image.dart';

abstract class ImagesOutputPort {
  Future<List<Image>> findAll();
  Future<Image?> findById(String id);
  Future<List<Image>> findByRepository(String repo);
  Future<String> findSchemeById(String id);
  Future<bool> deleteById(String id);
}
