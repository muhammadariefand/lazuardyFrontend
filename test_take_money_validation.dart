import 'dart:convert';
import 'dart:io';

void main() async {
  final baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  final token = '34|dLKO2AuUmRfmOXyPHG2LvDxpT5zVgoRGd6DlI3OP24a294c8';
  final client = HttpClient();
  
  print('Submitting Payout with missing fields...');
  final url = Uri.parse('$baseUrl/tutor/take-money');
  final req = await client.postUrl(url);
  req.headers.add('Authorization', 'Bearer $token');
  req.headers.add('Accept', 'application/json');
  req.headers.add('Content-Type', 'application/json');
  req.write(jsonEncode({
    'amount': 10000,
  }));
  final res = await req.close();
  print('Status: ${res.statusCode}');
  print('Body: ${await res.transform(utf8.decoder).join()}');
}
