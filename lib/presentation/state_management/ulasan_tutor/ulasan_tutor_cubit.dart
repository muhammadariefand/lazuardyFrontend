import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/siswa/get_student_reviews_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/ulasan_tutor/ulasan_tutor_state.dart';

class UlasanTutorCubit extends Cubit<UlasanTutorState> {
  final GetStudentReviewsUseCase getStudentReviewsUseCase;

  UlasanTutorCubit({required this.getStudentReviewsUseCase}) : super(UlasanTutorInitial());

  int _page = 1;

  Future<void> fetchReviews({int? tutorId, int? minRating, int? maxRating}) async {
    if (state is UlasanTutorLoading) return;

    final currentState = state;
    var oldReviews = <ReviewEntity>[];
    if (currentState is UlasanTutorLoaded) {
      oldReviews = currentState.reviews;
    }

    emit(UlasanTutorLoading(oldReviews, isFirstFetch: _page == 1));

    try {
      final response = await getStudentReviewsUseCase.call(
        tutorId: tutorId,
        minRating: minRating,
        maxRating: maxRating,
        page: _page,
      );

      _page++;

      final newReviews = (state as UlasanTutorLoading).oldReviews;
      newReviews.addAll(response.data);

      if (!isClosed) {
        emit(UlasanTutorLoaded(
          reviews: newReviews,
          hasReachedMax: response.currentPage >= response.lastPage,
          currentPage: response.currentPage,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        if (e is ServerException) {
          emit(UlasanTutorError(e.message));
        } else {
          emit(const UlasanTutorError('Terjadi kesalahan yang tidak terduga'));
        }
      }
    }
  }

  void refreshReviews({int? tutorId, int? minRating, int? maxRating}) {
    _page = 1;
    emit(UlasanTutorInitial());
    fetchReviews(tutorId: tutorId, minRating: minRating, maxRating: maxRating);
  }
}
