import '../../domain/entities/tutor_entity.dart';

class TutorModel extends TutorEntity {
  TutorModel({
    required super.id,
    required super.name,
    super.email,
    super.telephoneNumber,
    super.profilePhotoUrl,
    super.description,
    required super.learningMethods,
    super.education,
    super.price,
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

    double? parsedPrice;
    if (json['price'] != null) {
      parsedPrice = double.tryParse(json['price'].toString());
    }

    List<Map<String, dynamic>>? parsedEducation;
    if (json['education'] != null && json['education'] is List) {
      parsedEducation = List<Map<String, dynamic>>.from(json['education']);
    }

    return TutorModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      telephoneNumber: json['telephoneNumber']?.toString(),
      profilePhotoUrl: json['profilePhotoUrl']?.toString(),
      description: json['description']?.toString(),
      learningMethods: methods,
      education: parsedEducation,
      price: parsedPrice,
      avgRate: parsedRate,
    );
  }
}