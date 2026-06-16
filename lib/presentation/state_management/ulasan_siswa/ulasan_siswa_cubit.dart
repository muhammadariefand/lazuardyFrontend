import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_reviews_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/ulasan_siswa/ulasan_siswa_state.dart';

class UlasanSiswaCubit extends Cubit<UlasanSiswaState> {
  final GetTutorReviewsUseCase getTutorReviewsUseCase;

  UlasanSiswaCubit({required this.getTutorReviewsUseCase}) : super(UlasanSiswaInitial());

  int _page = 1;

  Future<void> fetchReviews({int? studentId, int? minRating, int? maxRating}) async {
    if (state is UlasanSiswaLoading) return;

    final currentState = state;
    var oldReviews = <ReviewEntity>[];
    var avgRating = 0.0;
    if (currentState is UlasanSiswaLoaded) {
      oldReviews = currentState.reviews;
      avgRating = currentState.avgRating;
    } else if (currentState is UlasanSiswaLoading) {
      oldReviews = currentState.oldReviews;
      avgRating = currentState.avgRating;
    }

    emit(UlasanSiswaLoading(oldReviews, avgRating: avgRating, isFirstFetch: _page == 1));

    try {
      final response = await getTutorReviewsUseCase.call(
        studentId: studentId,
        minRating: minRating,
        maxRating: maxRating,
        page: _page,
      );

      _page++;

      final newReviews = (state as UlasanSiswaLoading).oldReviews;
      newReviews.addAll(response.reviews.data);

      if (!isClosed) {
        emit(UlasanSiswaLoaded(
          reviews: newReviews,
          avgRating: response.avgRating,
          hasReachedMax: response.reviews.currentPage >= response.reviews.lastPage,
          currentPage: response.reviews.currentPage,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        if (e is ServerException) {
          emit(UlasanSiswaError(e.message));
        } else {
          emit(const UlasanSiswaError('Terjadi kesalahan yang tidak terduga'));
        }
      }
    }
  }

  void refreshReviews({int? studentId, int? minRating, int? maxRating}) {
    _page = 1;
    emit(UlasanSiswaInitial());
    fetchReviews(studentId: studentId, minRating: minRating, maxRating: maxRating);
  }
}
