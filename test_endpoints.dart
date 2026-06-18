import 'dart:convert';
import 'dart:io';

void main() async {
  final baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  final token = '34|dLKO2AuUmRfmOXyPHG2LvDxpT5zVgoRGd6DlI3OP24a294c8';
  final client = HttpClient();
  
  final urls = [
    '$baseUrl/tutor/take-money',
    '$baseUrl/tutor/payout',
    '$baseUrl/tutor/withdraw',
    '$baseUrl/payout'
  ];
  
  for (var url in urls) {
    print('Trying POST $url ...');
    final req = await client.postUrl(Uri.parse(url));
    req.headers.add('Authorization', 'Bearer $token');
    req.headers.add('Accept', 'application/json');
    req.headers.add('Content-Type', 'application/json');
    req.write(jsonEncode({
      'amount': 10000,
      'bank_account_id': '1122334455',
      'note': 'Test withdraw'
    }));
    final res = await req.close();
    print('Status: ${res.statusCode}');
    if (res.statusCode != 500 && res.statusCode != 404) {
      print('Body: ${await res.transform(utf8.decoder).join()}');
    } else {
      await res.drain();
    }
  }
}
