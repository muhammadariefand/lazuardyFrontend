import '../../repositories/schedule_repository.dart';

class SubmitReviewUseCase {
  final ScheduleRepository repository;

  SubmitReviewUseCase(this.repository);

  Future<void> execute({
    required int tutorId,
    required double rate,
    required String comment,
  }) {
    return repository.submitReview(
      tutorId: tutorId,
      rate: rate,
      comment: comment,
    );
  }
}
