import 'dart:convert';
import 'dart:io';

void main() async {
  final baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  final token = '34|dLKO2AuUmRfmOXyPHG2LvDxpT5zVgoRGd6DlI3OP24a294c8';
  final client = HttpClient();
  
  // Test with tutor_id
  final url1 = Uri.parse('$baseUrl/getTutorById?tutor_id=10');
  final req1 = await client.getUrl(url1);
  req1.headers.add('Authorization', 'Bearer $token');
  req1.headers.add('Accept', 'application/json');
  final res1 = await req1.close();
  print('tutor_id=10: ${await res1.transform(utf8.decoder).join()}');
  
  // Test with id
  final url2 = Uri.parse('$baseUrl/getTutorById?id=10');
  final req2 = await client.getUrl(url2);
  req2.headers.add('Authorization', 'Bearer $token');
  req2.headers.add('Accept', 'application/json');
  final res2 = await req2.close();
  print('id=10: ${await res2.transform(utf8.decoder).join()}');
  
  // Test with user_id
  final url3 = Uri.parse('$baseUrl/getTutorById?user_id=10');
  final req3 = await client.getUrl(url3);
  req3.headers.add('Authorization', 'Bearer $token');
  req3.headers.add('Accept', 'application/json');
  final res3 = await req3.close();
  print('user_id=10: ${await res3.transform(utf8.decoder).join()}');
}
