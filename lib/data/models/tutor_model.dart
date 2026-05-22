import '../../domain/entities/tutor_entity.dart';

class TutorModel extends TutorEntity {
  TutorModel({
    required super.id,
    required super.name,
    super.profilePhotoUrl,
    super.description,
    required super.learningMethods,
    super.avgRate,
  });

  factory TutorModel.fromJson(Map<String, dynamic> json) {
    // Mengubah List<dynamic> dari API menjadi List<String>
    final rawMethods = json['learningMethod'] as List<dynamic>?;
    final List<String> methods = rawMethods?.map((e) => e.toString()).toList() ?? [];

    // Mengamankan nilai avgRate (bisa int, double, atau null di JSON)
    double? parsedRate;
    if (json['avgRate'] != null) {
      parsedRate = double.tryParse(json['avgRate'].toString());
    }

    return TutorModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      profilePhotoUrl: json['profilePhotoUrl']?.toString(),
      description: json['description']?.toString(),
      learningMethods: methods,
      avgRate: parsedRate,
    );
  }
}