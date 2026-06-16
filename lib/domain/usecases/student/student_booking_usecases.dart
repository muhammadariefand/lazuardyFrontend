import '../../entities/subject_entity.dart';
import '../../entities/tutor_entity.dart';
import '../../entities/tutor_availability_entity.dart';
import '../../entities/paginated_data_entity.dart';
import '../../repositories/student_booking_repository.dart';

class GetJenjangUseCase {
  final StudentBookingRepository repository;
  GetJenjangUseCase(this.repository);

  Future<List<String>> execute() {
    return repository.getJenjang();
  }
}

class GetClassesByLevelUseCase {
  final StudentBookingRepository repository;
  GetClassesByLevelUseCase(this.repository);

  Future<List<SubjectEntity>> execute(String level) {
    return repository.getClassesByLevel(level);
  }
}

class GetTutorsByCriteriaUseCase {
  final StudentBookingRepository repository;
  GetTutorsByCriteriaUseCase(this.repository);

  Future<PaginatedDataEntity<TutorEntity>> execute({
    int? subjectId,
    String? subjectName,
    int? classId,
    String? className,
    String? level,
    double? minRate,
    double? maxRate,
    int page = 1,
  }) {
    return repository.getTutorsByCriteria(
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
}

class GetTutorByIdUseCase {
  final StudentBookingRepository repository;
  GetTutorByIdUseCase(this.repository);

  Future<TutorEntity> execute(int id) {
    return repository.getTutorById(id);
  }
}

class GetTutorSchedulesUseCase {
  final StudentBookingRepository repository;
  GetTutorSchedulesUseCase(this.repository);

  Future<PaginatedDataEntity<TutorAvailabilityEntity>> execute({
    required int tutorId,
    String? day,
    int page = 1,
  }) {
    return repository.getTutorSchedulesByDay(
      tutorId: tutorId,
      day: day,
      page: page,
    );
  }
}

class TakeMeetingUseCase {
  final StudentBookingRepository repository;
  TakeMeetingUseCase(this.repository);

  Future<void> execute({
    required int tutorId,
    required int subjectId,
    required String date,
    required String time,
    required String learningMethod,
    required String address,
  }) {
    return repository.takeMeeting(
      tutorId: tutorId,
      subjectId: subjectId,
      date: date,
      time: time,
      learningMethod: learningMethod,
      address: address,
    );
  }
}
