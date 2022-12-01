import 'package:docker_client_app/domain/networks/network.dart';

abstract class NetworksOutputPort {
  Future<List<Network>> findAll();
  Future<Network?> findById(String id);
  Future<List<Network>> findByName(String name);
  Future<List<Network>> findByContainer(String containerId);
}
