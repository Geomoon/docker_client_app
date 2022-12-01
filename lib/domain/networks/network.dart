class Network {
  String? id;
  String? name;
  String? scope;
  String? driver;
  String? subnet;
  String? gateway;
  DateTime? createdAt;

  Network({
    this.id,
    this.name,
    this.scope,
    this.driver,
    this.subnet,
    this.gateway,
    this.createdAt,
  });

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
