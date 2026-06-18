import 'dart:convert';
import 'dart:io';

void main() async {
  final baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  final client = HttpClient();

  final loginUrl = Uri.parse('$baseUrl/login');
  final loginReq = await client.postUrl(loginUrl);
  loginReq.headers.contentType = ContentType.json;
  loginReq.write(jsonEncode({
    'email': 'siswa@example.com',
    'password': 'password',
  }));
  final loginRes = await loginReq.close();
  final loginBody = await loginRes.transform(utf8.decoder).join();
  
  String? token;
  try {
    final data = jsonDecode(loginBody);
    token = data['access_token'];
  } catch (e) {}

  if (token != null) {
    print('Logged in successfully!');
    final endpointsToTest = [
      '/package/history',
      '/order/history',
      '/package/orders',
      '/student/orders',
      '/packages/history',
      '/student/payment/history',
      '/payment/history',
      '/student/payment',
      '/student/payments'
    ];

    for (final ep in endpointsToTest) {
      final url = Uri.parse('$baseUrl$ep');
      final req = await client.getUrl(url);
      req.headers.add('Authorization', 'Bearer $token');
      req.headers.add('Accept', 'application/json');
      final res2 = await req.close();
      final body = await res2.transform(utf8.decoder).join();
      print('Endpoint: $ep -> Status: ${res2.statusCode}');
      if (res2.statusCode == 200 || res2.statusCode == 201) {
        print('Response: $body');
      }
    }
  } else {
    print('Failed to login. Body: $loginBody');
  }
}
