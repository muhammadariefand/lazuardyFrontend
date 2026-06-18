class SubjectEntity {
  final int id;
  final String name;
  final String? level;

  SubjectEntity({
    required this.id,
    required this.name,
    this.level,
  });

  factory SubjectEntity.fromJson(Map<String, dynamic> json) {
    return SubjectEntity(
      id: json['id'],
      name: json['name'],
      level: json['level'],
    );
  }
}
