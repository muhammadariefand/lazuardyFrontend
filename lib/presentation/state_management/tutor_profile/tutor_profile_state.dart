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
