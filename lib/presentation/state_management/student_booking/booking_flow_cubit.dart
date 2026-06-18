import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/student/student_booking_usecases.dart';
import 'booking_flow_state.dart';

class BookingFlowCubit extends Cubit<BookingFlowState> {
  final GetJenjangUseCase getJenjangUseCase;
  final GetClassesByLevelUseCase getClassesByLevelUseCase;
  final GetSubjectsByLevelUseCase getSubjectsByLevelUseCase;
  final GetTutorsByCriteriaUseCase getTutorsByCriteriaUseCase;
  final GetTutorByIdUseCase getTutorByIdUseCase;
  final GetTutorSchedulesUseCase getTutorSchedulesUseCase;
  final TakeMeetingUseCase takeMeetingUseCase;

  BookingFlowCubit({
    required this.getJenjangUseCase,
    required this.getClassesByLevelUseCase,
    required this.getSubjectsByLevelUseCase,
    required this.getTutorsByCriteriaUseCase,
    required this.getTutorByIdUseCase,
    required this.getTutorSchedulesUseCase,
    required this.takeMeetingUseCase,
  }) : super(BookingFlowInitial());

  Future<void> fetchJenjang() async {
    emit(BookingFlowLoading());
    try {
      final jenjangList = await getJenjangUseCase.execute();
      emit(JenjangLoaded(jenjangList));
    } catch (e) {
      emit(BookingFlowError(e.toString()));
    }
  }

  Future<void> fetchClasses(String level) async {
    emit(BookingFlowLoading());
    try {
      final classes = await getClassesByLevelUseCase.execute(level);
      emit(ClassesLoaded(classes));
    } catch (e) {
      emit(BookingFlowError(e.toString()));
    }
  }

  Future<void> fetchSubjectsByLevel(String level) async {
    emit(BookingFlowLoading());
    try {
      final subjects = await getSubjectsByLevelUseCase.execute(level);
      emit(ClassesLoaded(subjects));
    } catch (e) {
      emit(BookingFlowError(e.toString()));
    }
  }

  Future<void> fetchTutorsByCriteria({
    int? subjectId,
    String? subjectName,
    int? classId,
    String? className,
    String? level,
    double? minRate,
    double? maxRate,
    int page = 1,
  }) async {
    emit(BookingFlowLoading());
    try {
      final paginatedData = await getTutorsByCriteriaUseCase.execute(
        subjectId: subjectId,
        subjectName: subjectName,
        classId: classId,
        className: className,
        level: level,
        minRate: minRate,
        maxRate: maxRate,
        page: page,
      );
      emit(TutorsLoaded(paginatedData.data));
    } catch (e) {
      emit(BookingFlowError(e.toString()));
    }
  }

  Future<void> fetchTutorDetail(int id) async {
    emit(BookingFlowLoading());
    try {
      final tutor = await getTutorByIdUseCase.execute(id);
      emit(TutorDetailLoaded(tutor));
    } catch (e) {
      if (e.toString().contains('Gagal mengambil biodata tutor') ||
          e.toString().contains('tidak ditemukan')) {
        // Abaikan error biodata yang tidak ada agar user tetap bisa booking
        emit(BookingFlowInitial());
      } else {
        emit(BookingFlowError(e.toString()));
      }
    }
  }

  Future<void> fetchTutorSchedules(int tutorId, String day) async {
    emit(BookingFlowLoading());
    try {
      final paginatedData = await getTutorSchedulesUseCase.execute(
        tutorId: tutorId,
        day: day,
      );
      emit(TutorSchedulesLoaded(paginatedData.data));
    } catch (e) {
      emit(BookingFlowError(e.toString()));
    }
  }

  Future<void> submitBooking({
    required int tutorId,
    required int subjectId,
    required String date,
    required String time,
    required String learningMethod,
    required String address,
  }) async {
    emit(BookingFlowLoading());
    try {
      await takeMeetingUseCase.execute(
        tutorId: tutorId,
        subjectId: subjectId,
        date: date,
        time: time,
        learningMethod: learningMethod,
        address: address,
      );
      emit(BookingSubmitSuccess());
    } catch (e) {
      emit(BookingFlowError(e.toString()));
    }
  }
}
