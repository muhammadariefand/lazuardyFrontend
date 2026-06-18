import 'dart:convert';
import 'dart:io';

void main() async {
  final url = Uri.parse('https://lazuardybackend-hexa.onrender.com/api/getTutorById?tutor_id=1');
  final request = await HttpClient().getUrl(url);
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  print('GET /getTutorById: $responseBody');

  final url2 = Uri.parse('https://lazuardybackend-hexa.onrender.com/api/schedule/getTutorSchedulesByDay?tutor_id=1&day=senin');
  final request2 = await HttpClient().getUrl(url2);
  final response2 = await request2.close();
  final responseBody2 = await response2.transform(utf8.decoder).join();
  print('GET /schedule/getTutorSchedulesByDay: $responseBody2');
}
