import 'package:equatable/equatable.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_availability_entity.dart';

abstract class ProfilMengajarState extends Equatable {
  const ProfilMengajarState();

  @override
  List<Object?> get props => [];
}

class ProfilMengajarInitial extends ProfilMengajarState {}

class ProfilMengajarLoading extends ProfilMengajarState {}

class ProfilMengajarLoaded extends ProfilMengajarState {
  final TutorEntity tutorProfile;
  final List<TutorAvailabilityEntity> schedules;
  final bool isSubmitting;
  final String? submitSuccessMessage;
  final String? submitErrorMessage;

  const ProfilMengajarLoaded({
    required this.tutorProfile,
    required this.schedules,
    this.isSubmitting = false,
    this.submitSuccessMessage,
    this.submitErrorMessage,
  });

  ProfilMengajarLoaded copyWith({
    TutorEntity? tutorProfile,
    List<TutorAvailabilityEntity>? schedules,
    bool? isSubmitting,
    String? submitSuccessMessage,
    String? submitErrorMessage,
    bool clearMessages = false,
  }) {
    return ProfilMengajarLoaded(
      tutorProfile: tutorProfile ?? this.tutorProfile,
      schedules: schedules ?? this.schedules,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccessMessage: clearMessages ? null : (submitSuccessMessage ?? this.submitSuccessMessage),
      submitErrorMessage: clearMessages ? null : (submitErrorMessage ?? this.submitErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
        tutorProfile,
        schedules,
        isSubmitting,
        submitSuccessMessage,
        submitErrorMessage,
      ];
}

class ProfilMengajarError extends ProfilMengajarState {
  final String message;

  const ProfilMengajarError(this.message);

  @override
  List<Object?> get props => [message];
}
