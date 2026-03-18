import 'package:lazuadry_mobile_fe/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
}