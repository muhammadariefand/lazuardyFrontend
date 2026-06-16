import 'package:equatable/equatable.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';

abstract class UlasanSiswaState extends Equatable {
  const UlasanSiswaState();

  @override
  List<Object> get props => [];
}

class UlasanSiswaInitial extends UlasanSiswaState {}

class UlasanSiswaLoading extends UlasanSiswaState {
  final List<ReviewEntity> oldReviews;
  final double avgRating;
  final bool isFirstFetch;

  const UlasanSiswaLoading(this.oldReviews, {this.avgRating = 0.0, this.isFirstFetch = false});

  @override
  List<Object> get props => [oldReviews, avgRating, isFirstFetch];
}

class UlasanSiswaLoaded extends UlasanSiswaState {
  final List<ReviewEntity> reviews;
  final double avgRating;
  final bool hasReachedMax;
  final int currentPage;

  const UlasanSiswaLoaded({
    required this.reviews,
    required this.avgRating,
    required this.hasReachedMax,
    required this.currentPage,
  });

  @override
  List<Object> get props => [reviews, avgRating, hasReachedMax, currentPage];
}

class UlasanSiswaError extends UlasanSiswaState {
  final String message;

  const UlasanSiswaError(this.message);

  @override
  List<Object> get props => [message];
}
