import 'package:equatable/equatable.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';

abstract class UlasanTutorState extends Equatable {
  const UlasanTutorState();

  @override
  List<Object> get props => [];
}

class UlasanTutorInitial extends UlasanTutorState {}

class UlasanTutorLoading extends UlasanTutorState {
  final List<ReviewEntity> oldReviews;
  final bool isFirstFetch;

  const UlasanTutorLoading(this.oldReviews, {this.isFirstFetch = false});

  @override
  List<Object> get props => [oldReviews, isFirstFetch];
}

class UlasanTutorLoaded extends UlasanTutorState {
  final List<ReviewEntity> reviews;
  final bool hasReachedMax;
  final int currentPage;

  const UlasanTutorLoaded({
    required this.reviews,
    required this.hasReachedMax,
    required this.currentPage,
  });

  @override
  List<Object> get props => [reviews, hasReachedMax, currentPage];
}

class UlasanTutorError extends UlasanTutorState {
  final String message;

  const UlasanTutorError(this.message);

  @override
  List<Object> get props => [message];
}
