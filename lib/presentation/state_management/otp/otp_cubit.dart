import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/otp_response.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/otp_repository.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final OtpRepository repository;
  
  OtpCubit(this.repository) : super(OtpInitial());

  Future<void> sendOtp(String email) async {
    emit(OtpLoading());

    // Memanggil fungsi di Data Layer
    final result = await repository.sendEmail(email);

    // Pattern matching untuk mengecek hasil dari Repository
    if (result is OtpSuccess) {
      emit(OtpSendSuccess(result.status));
    } else if (result is OtpFailure) {
      emit(OtpSendError(result.message));
    }
  }
}