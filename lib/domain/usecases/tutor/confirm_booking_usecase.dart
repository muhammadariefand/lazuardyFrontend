import '../../repositories/schedule_repository.dart';

class ConfirmBookingUseCase {
  final ScheduleRepository repository;

  ConfirmBookingUseCase(this.repository);

  Future<void> execute({
    required int scheduleId,
    required String decision,
    String? urlMeeting,
  }) {
    return repository.confirmBooking(
      scheduleId: scheduleId,
      decision: decision,
      urlMeeting: urlMeeting,
    );
  }
}
