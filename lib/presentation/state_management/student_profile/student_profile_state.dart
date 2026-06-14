import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';

abstract class StudentProfileState {}

class StudentProfileInitial extends StudentProfileState {}

class StudentProfileLoading extends StudentProfileState {}

class StudentProfileLoaded extends StudentProfileState {
  final StudentBiodata biodata;

  StudentProfileLoaded(this.biodata);
}

class StudentProfileError extends StudentProfileState {
  final String message;

  StudentProfileError(this.message);
}
