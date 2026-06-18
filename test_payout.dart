import 'dart:convert';
import 'dart:io';

void main() async {
  final baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  final token = '34|dLKO2AuUmRfmOXyPHG2LvDxpT5zVgoRGd6DlI3OP24a294c8';
  final client = HttpClient();
  
  // 1. Fetch History
  print('Fetching Payout History...');
  final url1 = Uri.parse('$baseUrl/tutor/payout/history');
  final req1 = await client.getUrl(url1);
  req1.headers.add('Authorization', 'Bearer $token');
  req1.headers.add('Accept', 'application/json');
  final res1 = await req1.close();
  print('History Status: ${res1.statusCode}');
  print('History Body: ${await res1.transform(utf8.decoder).join()}');
  
  // 2. Fetch Profile to see salary
  print('\nFetching Tutor Profile...');
  final url2 = Uri.parse('$baseUrl/tutor/dashboard/homepage');
  final req2 = await client.getUrl(url2);
  req2.headers.add('Authorization', 'Bearer $token');
  req2.headers.add('Accept', 'application/json');
  final res2 = await req2.close();
  print('Profile Status: ${res2.statusCode}');
  print('Profile Body: ${await res2.transform(utf8.decoder).join()}');
}
