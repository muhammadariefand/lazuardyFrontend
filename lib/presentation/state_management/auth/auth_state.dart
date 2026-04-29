abstract class AuthState{}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {
  final String error;
  final Map<String, dynamic>? errorDetails; // Tambahkan ini untuk menampung detail error

  AuthFailure(this.error, {this.errorDetails});
}