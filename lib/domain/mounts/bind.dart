import 'package:docker_client_app/domain/mounts/mount.dart';

class Bind implements Mount {
  String? source;
  String? destination;
  bool rw;

  Bind({this.source, this.destination, this.rw = true});

  @override
  String toString() {
    return '{\n'
        '\tsource: $source,\n'
        '\tdestination: $destination,\n'
        '\trw: $rw\n'
        '}';
  }
}
