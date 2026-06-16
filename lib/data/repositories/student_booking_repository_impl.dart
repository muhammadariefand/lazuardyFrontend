import '../../domain/entities/subject_entity.dart';
import '../../domain/entities/tutor_entity.dart';
import '../../domain/entities/tutor_availability_entity.dart';
import '../../domain/entities/paginated_data_entity.dart';
import '../../domain/repositories/student_booking_repository.dart';
import '../datasources/student_booking_remote_ds.dart';

class StudentBookingRepositoryImpl implements StudentBookingRepository {
  final StudentBookingRemoteDataSource remoteDataSource;

  StudentBookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<String>> getJenjang() {
    return remoteDataSource.getJenjang();
  }

  @override
  Future<List<SubjectEntity>> getClassesByLevel(String level) {
    return remoteDataSource.getClassesByLevel(level);
  }

  @override
  Future<PaginatedDataEntity<TutorEntity>> getTutorsByCriteria({
    int? subjectId,
    String? subjectName,
    int? classId,
    String? className,
    String? level,
    double? minRate,
    double? maxRate,
    int page = 1,
  }) {
    return remoteDataSource.getTutorsByCriteria(
      subjectId: subjectId,
      subjectName: subjectName,
      classId: classId,
      className: className,
      level: level,
      minRate: minRate,
      maxRate: maxRate,
      page: page,
    );
  }

  @override
  Future<TutorEntity> getTutorById(int id) {
    return remoteDataSource.getTutorById(id);
  }

  @override
  Future<PaginatedDataEntity<TutorAvailabilityEntity>> getTutorSchedulesByDay({
    required int tutorId,
    String? day,
    int page = 1,
  }) {
    return remoteDataSource.getTutorSchedulesByDay(
      tutorId: tutorId,
      day: day,
      page: page,
    );
  }

  @override
  Future<void> takeMeeting({
    required int tutorId,
    required int subjectId,
    required String date,
    required String time,
    required String learningMethod,
    required String address,
  }) {
    return remoteDataSource.takeMeeting(
      tutorId: tutorId,
      subjectId: subjectId,
      date: date,
      time: time,
      learningMethod: learningMethod,
      address: address,
    );
  }
}
