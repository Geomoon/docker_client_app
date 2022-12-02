class ImageDH {
  String name;
  String description;
  int? pullCount;
  int? starCount;
  bool isTrusted;
  bool isOfficial;
  bool isAutomated;

  ImageDH({
    required this.name,
    required this.description,
    required this.pullCount,
    required this.starCount,
    required this.isTrusted,
    required this.isOfficial,
    required this.isAutomated,
  });

  ImageDH.fromJson(Map json)
      : name = json['name'],
        description = json['description'],
        pullCount = json['pull_count'],
        starCount = json['star_count'],
        isTrusted = json['is_trusted'],
        isAutomated = json['is_automated'],
        isOfficial = json['is_official'];

  @override
  String toString() => '{\n'
      '\tname: $name,\n'
      '\tdescription: $description,\n'
      '\tpullCount: $pullCount,\n'
      '\tstarCount: $starCount,\n'
      '\tisTrusted: $isTrusted,\n'
      '\tisOfficial: $isOfficial,\n'
      '\tisAutomated: $isAutomated\n'
      '}';
}
