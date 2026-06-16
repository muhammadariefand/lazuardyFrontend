class SubjectEntity {
  final int id;
  final String name;
  final String? level;

  SubjectEntity({
    required this.id,
    required this.name,
    this.level,
  });
}
