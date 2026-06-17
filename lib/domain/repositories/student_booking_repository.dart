import '../entities/subject_entity.dart';
import '../entities/tutor_entity.dart';
import '../entities/tutor_availability_entity.dart';
import '../entities/paginated_data_entity.dart';

abstract class StudentBookingRepository {
  Future<List<String>> getJenjang();
  
  Future<List<SubjectEntity>> getClassesByLevel(String level);
  
  Future<List<SubjectEntity>> getSubjectsByLevel(String level);
  
  Future<PaginatedDataEntity<TutorEntity>> getTutorsByCriteria({
    int? subjectId,
    String? subjectName,
    int? classId,
    String? className,
    String? level,
    double? minRate,
    double? maxRate,
    int page = 1,
  });
  
  Future<TutorEntity> getTutorById(int id);
  
  Future<PaginatedDataEntity<TutorAvailabilityEntity>> getTutorSchedulesByDay({
    required int tutorId,
    String? day,
    int page = 1,
  });
  
  Future<void> takeMeeting({
    required int tutorId,
    required int subjectId,
    required String date,
    required String time,
    required String learningMethod,
    required String address,
  });
}
