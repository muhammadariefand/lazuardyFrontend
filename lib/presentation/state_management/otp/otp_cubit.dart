// lib/presentation/cubits/otp/otp_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/domain/entities/otp_response.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/otp_repository.dart';

abstract class OtpState {}
class OtpInitial extends OtpState {}
class OtpLoading extends OtpState {}
// Ganti namanya di sini
class OtpSendSuccessState extends OtpState { final String message; OtpSendSuccessState(this.message); }
class OtpSendErrorState extends OtpState { final String message; OtpSendErrorState(this.message); }

class OtpCubit extends Cubit<OtpState> {
  final OtpRepository repository;
  OtpCubit(this.repository) : super(OtpInitial());

  Future<void> sendOtp(String email) async {
    emit(OtpLoading());
    try {
      final result = await repository.sendEmail(email);
      
      // Sekarang OtpSuccess merujuk ke Entity/Response karena tidak ada saingan nama lagi
      if (result is OtpSuccess) { 
        emit(OtpSendSuccessState(result.status)); 
      } else if (result is OtpFailure) {
        emit(OtpSendErrorState(result.message));
      }
    } catch (e) {
      emit(OtpSendErrorState("Terjadi kesalahan sistem"));
    }
  }
}