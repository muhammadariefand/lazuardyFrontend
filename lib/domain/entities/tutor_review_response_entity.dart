import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';

class TutorReviewResponseEntity {
  final double avgRating;
  final PaginatedDataEntity<ReviewEntity> reviews;

  TutorReviewResponseEntity({
    required this.avgRating,
    required this.reviews,
  });
}
