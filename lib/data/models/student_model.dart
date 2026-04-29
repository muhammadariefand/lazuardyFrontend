import 'package:lazuadry_mobile_fe/data/models/home_address_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';

class StudentModel extends StudentBiodata {
  StudentModel({
    super.id,
    super.name,
    super.email,
    super.emailVerifiedAt,
    super.googleId,
    super.facebookId,
    super.role,
    super.warning,
    super.sanction,
    super.telephoneNumber,
    super.telephoneVerifiedAt,
    super.profilePhotoUrl,
    super.dateOfBirth,
    super.gender,
    super.religion,
    super.homeAddress,
    super.latitude,
    super.longitude,
    super.session,
    super.classId,
  });
 
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel (
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['emailVerifiedAt'] as String?,
      googleId: json['googleId'] as String?,
      facebookId: json['facebookId'] as String?,
      role: json['role'] as String?,
      warning: json['warning'] is int ? json['warning'] as int : int.tryParse(json['warning']?.toString() ?? ''),
      sanction: json['sanction'] as String?,
      telephoneNumber: json['telephoneNumber'] as String?,
      telephoneVerifiedAt: json['telephoneVerifiedAt'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      religion: json['religion'] as String?,
      homeAddress: json['homeAddress'] != null
          ? HomeAddressModel.fromJson(json['homeAddress'] as Map<String, dynamic>)
          : null,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      session: json['session'] as String?,
      classId: json['classId'] is int ? json['classId'] as int : int.tryParse(json['classId']?.toString() ?? ''),
    );
  }

}