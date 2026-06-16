import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/get_student_biodata_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/update_student_biodata_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/update_profile_photo_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_state.dart';

class StudentProfileCubit extends Cubit<StudentProfileState> {
  final GetStudentBiodataUseCase getStudentBiodataUseCase;
  final UpdateStudentBiodataUseCase? updateStudentBiodataUseCase;
  final UpdateProfilePhotoUseCase? updateProfilePhotoUseCase;

  StudentProfileCubit({
    required this.getStudentBiodataUseCase,
    this.updateStudentBiodataUseCase,
    this.updateProfilePhotoUseCase,
  }) : super(StudentProfileInitial());

  Future<void> loadProfile() async {
    emit(StudentProfileLoading());
    try {
      final biodata = await getStudentBiodataUseCase.execute();
      emit(StudentProfileLoaded(biodata));
    } on ServerException catch (e) {
      emit(StudentProfileError(e.message));
    } catch (e) {
      emit(StudentProfileError('Terjadi kesalahan saat memuat profil.'));
    }
  }

  Future<void> updateBiodata(Map<String, dynamic> data) async {
    emit(StudentProfileUpdating());
    try {
      await updateStudentBiodataUseCase?.execute(data);
      emit(StudentProfileUpdateSuccess('Biodata berhasil diperbarui'));
    } on ServerException catch (e) {
      emit(StudentProfileUpdateError(e.message));
    } catch (e) {
      emit(StudentProfileUpdateError('Terjadi kesalahan saat memperbarui biodata.'));
    }
  }

  Future<void> uploadProfilePhoto(List<int> fileBytes, String fileName) async {
    emit(StudentPhotoUploading());
    try {
      await updateProfilePhotoUseCase?.execute(fileBytes, fileName);
      emit(StudentPhotoUploadSuccess('Foto profil berhasil diperbarui'));
    } on ServerException catch (e) {
      emit(StudentPhotoUploadError(e.message));
    } catch (e) {
      emit(StudentPhotoUploadError('Terjadi kesalahan saat memperbarui foto profil.'));
    }
  }
}
