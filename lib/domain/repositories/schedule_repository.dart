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
}
