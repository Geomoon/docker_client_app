class NetworkModel {
  String? id;
  String? name;
  String? scope;
  String? driver;
  String? subnet;
  String? gateway;
  DateTime? createdAt;

  NetworkModel({
    this.id,
    this.name,
    this.scope,
    this.driver,
    this.subnet,
    this.gateway,
    this.createdAt,
  });

  NetworkModel.fromJson(Map json)
      : id = json['Id'],
        name = json['Name'],
        createdAt = DateTime.tryParse(json['Created']),
        scope = json['Scope'],
        driver = json['Driver'],
        subnet = json['IPAM']['Config'][0]['Subnet'],
        gateway = json['IPAM']['Config'][0]['Gateway'];

  @override
  String toString() {
    return '{\n'
        '\tid: $id,\n'
        '\tname: $name,\n'
        '\tscope: $scope,\n'
        '\tdriver: $driver,\n'
        '\tsubnet: $subnet,\n'
        '\tgateway: $gateway,\n'
        '\tcreatedAt: $createdAt\n'
        '}';
  }
}
