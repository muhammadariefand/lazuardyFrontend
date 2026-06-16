import '../../../domain/entities/tutor_entity.dart';

abstract class TutorProfileState {}

class TutorProfileInitial extends TutorProfileState {}

class TutorProfileLoading extends TutorProfileState {}

class TutorProfileLoaded extends TutorProfileState {
  final TutorEntity tutor;
  TutorProfileLoaded(this.tutor);
}

class TutorProfileError extends TutorProfileState {
  final String message;
  TutorProfileError(this.message);
}

class TutorProfileUpdating extends TutorProfileState {}

class TutorProfileUpdateSuccess extends TutorProfileState {
  final String message;
  TutorProfileUpdateSuccess(this.message);
}

class TutorProfileUpdateError extends TutorProfileState {
  final String message;
  TutorProfileUpdateError(this.message);
}

class TutorPhotoUploading extends TutorProfileState {}

class TutorPhotoUploadSuccess extends TutorProfileState {
  final String message;
  TutorPhotoUploadSuccess(this.message);
}

class TutorPhotoUploadError extends TutorProfileState {
  final String message;
  TutorPhotoUploadError(this.message);
}
