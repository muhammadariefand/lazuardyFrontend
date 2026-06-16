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

// ── States khusus untuk update biodata ──────────────────────────
class StudentProfileUpdating extends StudentProfileState {}

class StudentProfileUpdateSuccess extends StudentProfileState {
  final String message;

  StudentProfileUpdateSuccess(this.message);
}

class StudentProfileUpdateError extends StudentProfileState {
  final String message;

  StudentProfileUpdateError(this.message);
}

// ── States khusus untuk update foto profil ──────────────────────
class StudentPhotoUploading extends StudentProfileState {}

class StudentPhotoUploadSuccess extends StudentProfileState {
  final String message;

  StudentPhotoUploadSuccess(this.message);
}

class StudentPhotoUploadError extends StudentProfileState {
  final String message;

  StudentPhotoUploadError(this.message);
}
