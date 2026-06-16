import '../entities/schedule_entity.dart';
import '../entities/paginated_data_entity.dart';

abstract class ScheduleRepository {
  Future<PaginatedDataEntity<ScheduleEntity>> getSchedules({
    required String status,
    required String date,
    int page = 1,
  });

  Future<void> confirmBooking({
    required int scheduleId,
    required String decision,
    String? urlMeeting,
  });

  Future<ScheduleEntity> getScheduleById(int scheduleId);

  Future<void> markScheduleComplete(int scheduleId);

  Future<void> submitReview({
    required int tutorId,
    required double rate,
    required String comment,
  });

  /// POST /schedule/cancel
  Future<void> cancelSchedule({
    required int scheduleId,
    required String reason,
  });
}

