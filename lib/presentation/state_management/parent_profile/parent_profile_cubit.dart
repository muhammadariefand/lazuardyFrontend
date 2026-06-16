import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/student_biodata.dart';
import '../../../domain/entities/server_exception.dart';
import '../../../domain/usecases/get_parent_profile_usecase.dart';

abstract class ParentProfileState {}

class ParentProfileInitial extends ParentProfileState {}

class ParentProfileLoading extends ParentProfileState {}

class ParentProfileLoaded extends ParentProfileState {
  final StudentBiodata profile;

  ParentProfileLoaded(this.profile);
}

class ParentProfileError extends ParentProfileState {
  final String message;

  ParentProfileError(this.message);
}

class ParentProfileCubit extends Cubit<ParentProfileState> {
  final GetParentProfileUseCase getParentProfileUseCase;

  ParentProfileCubit({required this.getParentProfileUseCase})
      : super(ParentProfileInitial());

  Future<void> loadProfile() async {
    emit(ParentProfileLoading());
    try {
      final profile = await getParentProfileUseCase.execute();
      emit(ParentProfileLoaded(profile));
    } on ServerException catch (e) {
      emit(ParentProfileError(e.message));
    } catch (e) {
      emit(ParentProfileError('Terjadi kesalahan yang tidak terduga.'));
    }
  }
}
