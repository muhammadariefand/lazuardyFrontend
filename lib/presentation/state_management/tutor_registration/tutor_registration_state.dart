import 'package:file_picker/file_picker.dart';
import 'package:lazuadry_mobile_fe/domain/entities/subject_entity.dart';

class TutorRegistrationData {
  String? email;
  String? password;
  String? name;
  String? gender;
  String? dob; // YYYY-MM-DD
  String? waNumber;
  String? bankCode;
  String? accountNumber;
  String? accountHolderName;
  PlatformFile? profilePhoto;

  String? province;
  String? regency;
  String? district;
  String? subdistrict;

  int? subjectId;
  List<String> learningMethods = [];
  String? bio;
  
  PlatformFile? cv;
  PlatformFile? idCard;
  PlatformFile? certificate;
}

abstract class TutorRegistrationState {}

class TutorRegistrationInitial extends TutorRegistrationState {}

class TutorRegistrationLoading extends TutorRegistrationState {}

class BankAccountValid extends TutorRegistrationState {
  final String accountHolderName;
  BankAccountValid(this.accountHolderName);
}

class SubjectsLoaded extends TutorRegistrationState {
  final List<SubjectEntity> subjects;
  SubjectsLoaded(this.subjects);
}

class TutorRegistrationSuccess extends TutorRegistrationState {
  final String message;
  TutorRegistrationSuccess(this.message);
}

class TutorRegistrationError extends TutorRegistrationState {
  final String message;
  final Map<String, dynamic>? errors;
  TutorRegistrationError(this.message, {this.errors});
}

// For intermediate steps like OTP sent / OTP verified
class OtpSentSuccess extends TutorRegistrationState {}
class OtpVerifiedSuccess extends TutorRegistrationState {}
