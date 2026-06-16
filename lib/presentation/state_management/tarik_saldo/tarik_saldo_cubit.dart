import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/payout_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_entity.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_payout_history_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/get_tutor_profile_usecase.dart';
import 'package:lazuadry_mobile_fe/domain/usecases/tutor/take_money_usecase.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tarik_saldo/tarik_saldo_state.dart';

class TarikSaldoCubit extends Cubit<TarikSaldoState> {
  final GetTutorProfileUseCase getTutorProfileUseCase;
  final GetPayoutHistoryUseCase getPayoutHistoryUseCase;
  final TakeMoneyUseCase takeMoneyUseCase;

  TarikSaldoCubit({
    required this.getTutorProfileUseCase,
    required this.getPayoutHistoryUseCase,
    required this.takeMoneyUseCase,
  }) : super(TarikSaldoInitial());

  int _page = 1;

  Future<void> initFetch() async {
    _page = 1;
    emit(const TarikSaldoLoading(isFirstFetch: true));

    try {
      final tutorProfile = await getTutorProfileUseCase.execute();
      
      final historyResponse = await getPayoutHistoryUseCase.call(page: _page);
      _page++;

      if (!isClosed) {
        emit(TarikSaldoLoaded(
          tutorProfile: tutorProfile,
          payouts: historyResponse.data,
          hasReachedMax: historyResponse.currentPage >= historyResponse.lastPage,
          currentPage: historyResponse.currentPage,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        if (e is ServerException) {
          emit(TarikSaldoError(e.message));
        } else {
          emit(const TarikSaldoError('Terjadi kesalahan yang tidak terduga'));
        }
      }
    }
  }

  Future<void> fetchMoreHistory() async {
    if (state is! TarikSaldoLoaded) return;
    final currentState = state as TarikSaldoLoaded;
    if (currentState.hasReachedMax) return;
    if (currentState.isSubmitting) return;

    // Temporary loading state if needed, or just silent fetch
    try {
      final historyResponse = await getPayoutHistoryUseCase.call(page: _page);
      _page++;

      final newPayouts = List<PayoutEntity>.from(currentState.payouts)..addAll(historyResponse.data);

      if (!isClosed) {
        emit(currentState.copyWith(
          payouts: newPayouts,
          hasReachedMax: historyResponse.currentPage >= historyResponse.lastPage,
          currentPage: historyResponse.currentPage,
        ));
      }
    } catch (e) {
      // Silently handle error or show snackbar
    }
  }

  Future<void> submitTakeMoney({
    required double amount,
    required String bankAccountId,
    required String note,
  }) async {
    if (state is! TarikSaldoLoaded) return;
    final currentState = state as TarikSaldoLoaded;

    emit(currentState.copyWith(isSubmitting: true, clearSubmitMessages: true));

    try {
      await takeMoneyUseCase.call(
        amount: amount,
        bankAccountId: bankAccountId,
        note: note,
      );

      // Successfully taken money, reload data to get new balance and history
      if (!isClosed) {
        emit(currentState.copyWith(
          isSubmitting: false,
          submitSuccessMessage: 'Permintaan penarikan saldo berhasil dikirim',
        ));
        // Re-fetch all data silently or completely
        initFetch(); 
      }
    } catch (e) {
      if (!isClosed) {
        String errorMessage = 'Gagal melakukan penarikan';
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

  void clearSubmitMessages() {
    if (state is TarikSaldoLoaded) {
      emit((state as TarikSaldoLoaded).copyWith(clearSubmitMessages: true));
    }
  }
}
