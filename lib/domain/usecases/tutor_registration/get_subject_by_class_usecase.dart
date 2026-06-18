import 'package:lazuadry_mobile_fe/domain/entities/subject_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tutor_registration_repository.dart';

class GetSubjectByClassUseCase {
  final TutorRegistrationRepository repository;

  GetSubjectByClassUseCase(this.repository);

  Future<List<SubjectEntity>> execute(int classId) async {
    return await repository.getSubjectByClass(classId);
  }
}
