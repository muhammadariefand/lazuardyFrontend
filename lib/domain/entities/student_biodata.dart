import 'package:lazuadry_mobile_fe/domain/entities/home_address.dart';

class StudentBiodata {
  String? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? googleId;
  String? facebookId;
  String? role;
  int? warning;
  String? sanction;
  String? telephoneNumber;
  String? telephoneVerifiedAt;
  String? profilePhotoUrl;
  String? dateOfBirth;
  String? gender;
  String? religion;
  HomeAddress? homeAddress;
  String? latitude;
  String? longitude;
  String? session;
  int? classId;
  String? className;

  StudentBiodata({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.googleId,
    this.facebookId,
    this.role,
    this.warning,
    this.sanction,
    this.telephoneNumber,
    this.telephoneVerifiedAt,
    this.profilePhotoUrl,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.homeAddress,
    this.latitude,
    this.longitude,
    this.session,
    this.classId,
    this.className,
  });
}
