abstract class OtpState {}

class OtpInitial extends OtpState {}
class OtpLoading extends OtpState {}

// Gunakan nama yang spesifik agar tidak tabrakan dengan Entity
class OtpSendSuccess extends OtpState {
  final String message;
  OtpSendSuccess(this.message);
}

class OtpSendError extends OtpState {
  final String message;
  OtpSendError(this.message);
}