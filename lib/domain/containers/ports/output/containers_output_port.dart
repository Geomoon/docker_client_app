import 'package:docker_client_app/domain/containers/container.dart';

abstract class ContainersOutputPort {
  Future<List<Container>> findAll();
  Future<Container?> findById(String id);
  Future<List<Container>> findByName(String name);
  Future<List<Container>> findByImage(String imageId);
  Future<List<Container>> findByStatus(String status);
  Future<List<Container>> findByNetwork(String networkId);
}
