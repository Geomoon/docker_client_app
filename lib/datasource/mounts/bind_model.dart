import 'dart:convert';

class BindModel {
  String? source;
  String? destination;
  bool rw;

  BindModel({this.source, this.destination, this.rw = true});

  BindModel.fromJson(Map json)
      : source = json['Source'],
        destination = json['Destination'],
        rw = json['RW'];

  @override
  String toString() {
    return '{\n'
        '\tsource: $source,\n'
        '\tdestination: $destination,\n'
        '\trw: $rw\n'
        '}';
  }
}
