import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class RegisterParentUsecase {
  final AuthRepository repository;
  
  RegisterParentUsecase({required this.repository});
  
  Future<void> execute(String email, String password, String childEmail) async {
    return await repository.registerParent(email, password, childEmail);
  }
}