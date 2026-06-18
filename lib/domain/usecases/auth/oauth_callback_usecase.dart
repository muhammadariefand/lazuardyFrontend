import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class OAuthCallbackUsecase {
  final AuthRepository repository;

  OAuthCallbackUsecase(this.repository);

  Future<Map<String, dynamic>> execute(String provider, String idToken) {
    return repository.oauthCallback(provider, idToken);
  }
}
