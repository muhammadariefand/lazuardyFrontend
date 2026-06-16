import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';

abstract class StudentRepository {
  Future<StudentBiodata> getStudentBiodata();
  Future<void> updateStudentBiodata(Map<String, dynamic> data);
  Future<void> updateProfilePhoto(List<int> fileBytes, String fileName);
  Future<PaginatedDataEntity<ReviewEntity>> getStudentReviews({
    int? tutorId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  });
}
