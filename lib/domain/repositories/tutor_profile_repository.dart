import '../entities/tutor_entity.dart';

abstract class TutorProfileRepository {
  Future<TutorEntity> getTutorProfile();
  Future<void> updateTutorBiodata(Map<String, dynamic> data);
  Future<void> updateProfilePhoto(List<int> fileBytes, String fileName);
}
