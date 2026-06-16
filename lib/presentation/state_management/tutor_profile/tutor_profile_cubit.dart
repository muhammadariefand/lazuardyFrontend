import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/tutor/get_tutor_profile_usecase.dart';
import '../../../domain/usecases/tutor/update_tutor_biodata_usecase.dart';
import '../../../domain/usecases/tutor/update_tutor_profile_photo_usecase.dart';
import 'tutor_profile_state.dart';

class TutorProfileCubit extends Cubit<TutorProfileState> {
  final GetTutorProfileUseCase getTutorProfileUseCase;
  final UpdateTutorBiodataUseCase updateTutorBiodataUseCase;
  final UpdateTutorProfilePhotoUseCase updateTutorProfilePhotoUseCase;

  TutorProfileCubit({
    required this.getTutorProfileUseCase,
    required this.updateTutorBiodataUseCase,
    required this.updateTutorProfilePhotoUseCase,
  }) : super(TutorProfileInitial());

  Future<void> fetchProfile() async {
    emit(TutorProfileLoading());
    try {
      final tutor = await getTutorProfileUseCase.execute();
      emit(TutorProfileLoaded(tutor));
    } catch (e) {
      emit(TutorProfileError(e.toString()));
    }
  }

  Future<void> updateBiodata(Map<String, dynamic> data) async {
    emit(TutorProfileUpdating());
    try {
      await updateTutorBiodataUseCase.execute(data);
      emit(TutorProfileUpdateSuccess('Biodata tutor berhasil diperbarui'));
    } catch (e) {
      emit(TutorProfileUpdateError(e.toString()));
    }
  }

  Future<void> uploadProfilePhoto(List<int> fileBytes, String fileName) async {
    emit(TutorPhotoUploading());
    try {
      await updateTutorProfilePhotoUseCase.execute(fileBytes, fileName);
      emit(TutorPhotoUploadSuccess('Foto profil berhasil diperbarui'));
    } catch (e) {
      emit(TutorPhotoUploadError(e.toString()));
    }
  }
}
