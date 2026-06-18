import 'package:lazuadry_mobile_fe/domain/entities/tutor_entity.dart';
import 'package:lazuadry_mobile_fe/data/models/home_address_model.dart';

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
    super.salary,
    super.avgRate,
    super.dateOfBirth,
    super.gender,
    super.religion,
    super.homeAddress,
    super.bankCode,
    super.accountNumber,
    super.subjects,
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

    double? parsedSalary;
    if (json['salary'] != null) {
      parsedSalary = double.tryParse(json['salary'].toString());
    }

    List<Map<String, dynamic>>? parsedEducation;
    if (json['education'] != null && json['education'] is List) {
      parsedEducation = List<Map<String, dynamic>>.from(json['education']);
    }

    List<Map<String, dynamic>>? parsedSubjects;
    if (json['subjects'] != null && json['subjects'] is List) {
      parsedSubjects = List<Map<String, dynamic>>.from(json['subjects']);
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
      salary: parsedSalary,
      avgRate: parsedRate,
      dateOfBirth: json['dateOfBirth']?.toString(),
      gender: json['gender']?.toString(),
      religion: json['religion']?.toString(),
      homeAddress: json['homeAddress'] != null
          ? HomeAddressModel.fromJson(json['homeAddress'] as Map<String, dynamic>)
          : null,
      bankCode: json['bankCode']?.toString(),
      accountNumber: json['accountNumber']?.toString(),
      subjects: parsedSubjects,
    );
  }
}