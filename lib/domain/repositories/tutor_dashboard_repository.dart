import 'package:lazuadry_mobile_fe/domain/entities/tutor_dashboard_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_review_response_entity.dart';

abstract class TutorDashboardRepository {
  Future<TutorDashboardEntity> getHomepage({int notificationPage = 1});
  Future<TutorReviewResponseEntity> getTutorReviews({
    int? studentId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  });
}
