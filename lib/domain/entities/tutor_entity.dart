class TutorEntity {
  final String id;
  final String name;
  final String? email;
  final String? telephoneNumber;
  final String? profilePhotoUrl;
  final String? description;
  final List<String> learningMethods;
  final List<Map<String, dynamic>>? education;
  final double? price;
  final double? salary;
  final double? avgRate;
  final String? dateOfBirth;
  final String? gender;
  final String? religion;
  final String? homeAddress;
  final String? bankCode;
  final String? accountNumber;
  final List<Map<String, dynamic>>? subjects;

  TutorEntity({
    required this.id,
    required this.name,
    this.email,
    this.telephoneNumber,
    this.profilePhotoUrl,
    this.description,
    required this.learningMethods,
    this.education,
    this.price,
    this.salary,
    this.avgRate,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.homeAddress,
    this.bankCode,
    this.accountNumber,
    this.subjects,
  });
}