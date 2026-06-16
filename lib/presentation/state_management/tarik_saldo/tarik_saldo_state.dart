import 'package:equatable/equatable.dart';
import 'package:lazuadry_mobile_fe/domain/entities/payout_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_entity.dart';

abstract class TarikSaldoState extends Equatable {
  const TarikSaldoState();

  @override
  List<Object?> get props => [];
}

class TarikSaldoInitial extends TarikSaldoState {}

class TarikSaldoLoading extends TarikSaldoState {
  final TutorEntity? tutorProfile;
  final List<PayoutEntity> oldPayouts;
  final bool isFirstFetch;

  const TarikSaldoLoading({
    this.tutorProfile,
    this.oldPayouts = const [],
    this.isFirstFetch = false,
  });

  @override
  List<Object?> get props => [tutorProfile, oldPayouts, isFirstFetch];
}

class TarikSaldoLoaded extends TarikSaldoState {
  final TutorEntity tutorProfile;
  final List<PayoutEntity> payouts;
  final bool hasReachedMax;
  final int currentPage;
  
  // States for submission
  final bool isSubmitting;
  final String? submitSuccessMessage;
  final String? submitErrorMessage;

  const TarikSaldoLoaded({
    required this.tutorProfile,
    required this.payouts,
    required this.hasReachedMax,
    required this.currentPage,
    this.isSubmitting = false,
    this.submitSuccessMessage,
    this.submitErrorMessage,
  });

  TarikSaldoLoaded copyWith({
    TutorEntity? tutorProfile,
    List<PayoutEntity>? payouts,
    bool? hasReachedMax,
    int? currentPage,
    bool? isSubmitting,
    String? submitSuccessMessage,
    String? submitErrorMessage,
    bool clearSubmitMessages = false,
  }) {
    return TarikSaldoLoaded(
      tutorProfile: tutorProfile ?? this.tutorProfile,
      payouts: payouts ?? this.payouts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccessMessage: clearSubmitMessages ? null : (submitSuccessMessage ?? this.submitSuccessMessage),
      submitErrorMessage: clearSubmitMessages ? null : (submitErrorMessage ?? this.submitErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
        tutorProfile,
        payouts,
        hasReachedMax,
        currentPage,
        isSubmitting,
        submitSuccessMessage,
        submitErrorMessage,
      ];
}

class TarikSaldoError extends TarikSaldoState {
  final String message;

  const TarikSaldoError(this.message);

  @override
  List<Object?> get props => [message];
}
