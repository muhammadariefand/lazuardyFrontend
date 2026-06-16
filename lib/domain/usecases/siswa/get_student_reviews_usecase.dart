import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/student_repository.dart';

class GetStudentReviewsUseCase {
  final StudentRepository repository;

  GetStudentReviewsUseCase(this.repository);

  Future<PaginatedDataEntity<ReviewEntity>> call({
    int? tutorId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  }) {
    return repository.getStudentReviews(
      tutorId: tutorId,
      minRating: minRating,
      maxRating: maxRating,
      page: page,
      pagination: pagination,
    );
  }
}
