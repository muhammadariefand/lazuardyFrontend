import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/tutor/get_tutor_profile_usecase.dart';
import 'tutor_profile_state.dart';

class TutorProfileCubit extends Cubit<TutorProfileState> {
  final GetTutorProfileUseCase getTutorProfileUseCase;

  TutorProfileCubit({required this.getTutorProfileUseCase}) : super(TutorProfileInitial());

  Future<void> fetchProfile() async {
    emit(TutorProfileLoading());
    try {
      final tutor = await getTutorProfileUseCase.execute();
      emit(TutorProfileLoaded(tutor));
    } catch (e) {
      emit(TutorProfileError(e.toString()));
    }
  }
}
