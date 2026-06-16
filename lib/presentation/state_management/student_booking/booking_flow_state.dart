import '../../../domain/entities/subject_entity.dart';
import '../../../domain/entities/tutor_entity.dart';
import '../../../domain/entities/tutor_availability_entity.dart';

abstract class BookingFlowState {}

class BookingFlowInitial extends BookingFlowState {}

class BookingFlowLoading extends BookingFlowState {}

class JenjangLoaded extends BookingFlowState {
  final List<String> jenjangList;
  JenjangLoaded(this.jenjangList);
}

class ClassesLoaded extends BookingFlowState {
  final List<SubjectEntity> classes;
  ClassesLoaded(this.classes);
}

class TutorsLoaded extends BookingFlowState {
  final List<TutorEntity> tutors;
  TutorsLoaded(this.tutors);
}

class TutorDetailLoaded extends BookingFlowState {
  final TutorEntity tutor;
  TutorDetailLoaded(this.tutor);
}

class TutorSchedulesLoaded extends BookingFlowState {
  final List<TutorAvailabilityEntity> schedules;
  TutorSchedulesLoaded(this.schedules);
}

class BookingSubmitSuccess extends BookingFlowState {}

class BookingFlowError extends BookingFlowState {
  final String message;
  BookingFlowError(this.message);
}
