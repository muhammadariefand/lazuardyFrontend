import 'dart:convert';
import 'dart:io';

void main() async {
  final baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  final token = '34|dLKO2AuUmRfmOXyPHG2LvDxpT5zVgoRGd6DlI3OP24a294c8';
  final client = HttpClient();
  
  final url1 = Uri.parse('$baseUrl/getTutorByCriteria?page=1');
  final req1 = await client.getUrl(url1);
  req1.headers.add('Authorization', 'Bearer $token');
  req1.headers.add('Accept', 'application/json');
  final res1 = await req1.close();
  final body = await res1.transform(utf8.decoder).join();
  
  final data = jsonDecode(body);
  final tutors = data['data']['data'] as List;
  for (var t in tutors) {
    if (t['name'].toString().contains('Arief')) {
      print('FOUND TUTOR: ${t['id']} - ${t['name']}');
      
      // Try to fetch this tutor
      final tId = t['id'];
      final u2 = Uri.parse('$baseUrl/getTutorById?tutor_id=$tId');
      final r2 = await client.getUrl(u2);
      r2.headers.add('Authorization', 'Bearer $token');
      r2.headers.add('Accept', 'application/json');
      final res2 = await r2.close();
      print('getTutorById: ${await res2.transform(utf8.decoder).join()}');
    }
  }
}
