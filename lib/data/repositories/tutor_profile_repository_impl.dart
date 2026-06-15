import '../../domain/entities/tutor_entity.dart';
import '../../domain/repositories/tutor_profile_repository.dart';
import '../datasources/tutor_profile_remote_ds.dart';

class TutorProfileRepositoryImpl implements TutorProfileRepository {
  final TutorProfileRemoteDataSource remoteDataSource;

  TutorProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TutorEntity> getTutorProfile() async {
    return await remoteDataSource.getTutorProfile();
  }
}
