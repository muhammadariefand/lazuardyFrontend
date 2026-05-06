import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserToken(String token);
  Future<String?> getUserToken();
  Future<void> clearUserToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  static const String _tokenKey = 'CACHED_AUTH_TOKEN';

  @override
  Future<void> saveUserToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getUserToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> clearUserToken() async {
    await sharedPreferences.remove(_tokenKey);
  }
}