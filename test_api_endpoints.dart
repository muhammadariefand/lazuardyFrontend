import 'dart:convert';
import 'dart:io';

void main() async {
  final baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  final token = '34|dLKO2AuUmRfmOXyPHG2LvDxpT5zVgoRGd6DlI3OP24a294c8';
  final client = HttpClient();
  
  final urls = [
    '$baseUrl/tutors/12',
    '$baseUrl/tutor/12',
    '$baseUrl/getTutor/12',
    '$baseUrl/tutor-detail/12'
  ];
  
  for (var url in urls) {
    print('Trying $url ...');
    final req = await client.getUrl(Uri.parse(url));
    req.headers.add('Authorization', 'Bearer $token');
    req.headers.add('Accept', 'application/json');
    final res = await req.close();
    print('Status: ${res.statusCode}');
    if (res.statusCode == 200) {
      print('Body: ${await res.transform(utf8.decoder).join()}');
    } else {
      await res.drain();
    }
  }
}
