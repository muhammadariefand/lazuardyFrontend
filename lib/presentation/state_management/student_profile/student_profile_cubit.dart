import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/student/get_student_biodata_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_state.dart';

class StudentProfileCubit extends Cubit<StudentProfileState> {
  final GetStudentBiodataUseCase getStudentBiodataUseCase;

  StudentProfileCubit({required this.getStudentBiodataUseCase}) : super(StudentProfileInitial());

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
}
