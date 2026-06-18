import 'dart:convert';
import 'dart:io';

void main() async {
  final baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  final client = HttpClient();

  final token = '34|dLKO2AuUmRfmOXyPHG2LvDxpT5zVgoRGd6DlI3OP24a294c8';

  final endpointsToTest = [
    '/student/orders',
    '/student/order',
    '/packages/order/history',
    '/package/orders',
    '/order/history',
    '/student/payment/history',
  ];

  for (final ep in endpointsToTest) {
    final url = Uri.parse('$baseUrl$ep');
    final req = await client.getUrl(url);
    req.headers.add('Authorization', 'Bearer $token');
    req.headers.add('Accept', 'application/json');
    final res = await req.close();
    final body = await res.transform(utf8.decoder).join();
    print('Endpoint: $ep -> Status: ${res.statusCode}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      print('Response: $body');
    }
  }
}
