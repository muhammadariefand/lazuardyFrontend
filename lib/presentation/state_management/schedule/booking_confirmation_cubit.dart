import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/tutor/confirm_booking_usecase.dart';

abstract class BookingConfirmationState {}

class BookingConfirmationInitial extends BookingConfirmationState {}

class BookingConfirmationLoading extends BookingConfirmationState {}

class BookingConfirmationSuccess extends BookingConfirmationState {
  final String message;
  BookingConfirmationSuccess(this.message);
}

class BookingConfirmationError extends BookingConfirmationState {
  final String message;
  BookingConfirmationError(this.message);
}

class BookingConfirmationCubit extends Cubit<BookingConfirmationState> {
  final ConfirmBookingUseCase confirmBookingUseCase;

  BookingConfirmationCubit({required this.confirmBookingUseCase}) : super(BookingConfirmationInitial());

  Future<void> confirmBooking({required int scheduleId, required String decision, String? urlMeeting}) async {
    emit(BookingConfirmationLoading());
    try {
      await confirmBookingUseCase.execute(scheduleId: scheduleId, decision: decision, urlMeeting: urlMeeting);
      emit(BookingConfirmationSuccess('Booking berhasil diproses.'));
    } catch (e) {
      emit(BookingConfirmationError(e.toString()));
    }
  }
}
