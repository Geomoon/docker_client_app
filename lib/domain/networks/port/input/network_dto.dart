class NetworkDTO {
  String? id;
  String? name;
  String? scope;
  String? driver;
  String? subnet;
  String? gateway;
  DateTime? createdAt;

  NetworkDTO({
    this.id,
    this.name,
    this.scope,
    this.driver,
    this.subnet,
    this.createdAt,
    this.gateway,
  });
}
