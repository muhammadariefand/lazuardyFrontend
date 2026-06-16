import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_profile_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_schedules_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/update_teaching_profile_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/profil_mengajar/profil_mengajar_state.dart';

class ProfilMengajarCubit extends Cubit<ProfilMengajarState> {
  final GetTutorProfileUseCase getTutorProfileUseCase;
  final GetTeachingSchedulesUseCase getTutorSchedulesUseCase;
  final UpdateTeachingProfileUseCase updateTeachingProfileUseCase;

  ProfilMengajarCubit({
    required this.getTutorProfileUseCase,
    required this.getTutorSchedulesUseCase,
    required this.updateTeachingProfileUseCase,
  }) : super(ProfilMengajarInitial());

  Future<void> fetchProfileData() async {
    emit(ProfilMengajarLoading());
    try {
      final tutorProfile = await getTutorProfileUseCase.execute();
      
      final schedulesResponse = await getTutorSchedulesUseCase.execute(
        tutorId: int.parse(tutorProfile.id),
      );

      if (!isClosed) {
        emit(ProfilMengajarLoaded(
          tutorProfile: tutorProfile,
          schedules: schedulesResponse.data,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        if (e is ServerException) {
          emit(ProfilMengajarError(e.message));
        } else {
          emit(const ProfilMengajarError('Terjadi kesalahan yang tidak terduga saat memuat profil.'));
        }
      }
    }
  }

  Future<void> saveProfile({
    required String description,
    required List<String> learningMethods,
    required List<Map<String, String>> schedules,
  }) async {
    if (state is! ProfilMengajarLoaded) return;
    final currentState = state as ProfilMengajarLoaded;

    emit(currentState.copyWith(isSubmitting: true, clearMessages: true));

    try {
      await updateTeachingProfileUseCase.execute(
        description: description,
        learningMethods: learningMethods,
        schedules: schedules,
      );

      if (!isClosed) {
        emit(currentState.copyWith(
          isSubmitting: false,
          submitSuccessMessage: 'Profil mengajar berhasil diperbarui',
        ));
        // Refetch to get updated data from backend
        fetchProfileData();
      }
    } catch (e) {
      if (!isClosed) {
        String errorMessage = 'Gagal menyimpan profil mengajar';
        if (e is ServerException) {
          errorMessage = e.message;
        }
        emit(currentState.copyWith(
          isSubmitting: false,
          submitErrorMessage: errorMessage,
        ));
      }
    }
  }

  void clearMessages() {
    if (state is ProfilMengajarLoaded) {
      emit((state as ProfilMengajarLoaded).copyWith(clearMessages: true));
    }
  }
}
