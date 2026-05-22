class TutorEntity {
  final String id;
  final String name;
  final String? profilePhotoUrl;
  final String? description;
  final List<String> learningMethods;
  final double? avgRate;
  
  // Kamu bisa tambahkan data lain seperti education jika diperlukan di UI

  TutorEntity({
    required this.id,
    required this.name,
    this.profilePhotoUrl,
    this.description,
    required this.learningMethods,
    this.avgRate,
  });
}