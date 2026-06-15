import '../entities/tutor_entity.dart';

abstract class TutorProfileRepository {
  Future<TutorEntity> getTutorProfile();
}
