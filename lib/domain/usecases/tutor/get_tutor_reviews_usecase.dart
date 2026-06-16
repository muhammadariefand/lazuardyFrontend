import 'package:lazuadry_mobile_fe/domain/entities/tutor_review_response_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tutor_dashboard_repository.dart';

class GetTutorReviewsUseCase {
  final TutorDashboardRepository repository;

  GetTutorReviewsUseCase(this.repository);

  Future<TutorReviewResponseEntity> call({
    int? studentId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  }) {
    return repository.getTutorReviews(
      studentId: studentId,
      minRating: minRating,
      maxRating: maxRating,
      page: page,
      pagination: pagination,
    );
  }
}
