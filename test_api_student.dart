import 'dart:convert';
import 'dart:io';

void main() async {
  final baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  
  // Register a new student
  final client = HttpClient();
  
  // Use a random email
  final randomId = DateTime.now().millisecondsSinceEpoch;
  final email = 'test_student_$randomId@example.com';
  
  final registerUrl = Uri.parse('$baseUrl/register');
  final req = await client.postUrl(registerUrl);
  req.headers.contentType = ContentType.json;
  req.write(jsonEncode({
    'name': 'Test Student',
    'email': email,
    'password': 'password123',
    'password_confirmation': 'password123',
    'role': 'siswa'
  }));
  
  final res = await req.close();
  final resBody = await res.transform(utf8.decoder).join();
  print('REGISTER: $resBody');
  
  // Parse token
  String? token;
  try {
    final data = jsonDecode(resBody);
    token = data['access_token'];
  } catch (e) {
    print('Failed to parse token');
  }
  
  if (token == null) {
    // try login if register failed
    final loginUrl = Uri.parse('$baseUrl/login');
    final loginReq = await client.postUrl(loginUrl);
    loginReq.headers.contentType = ContentType.json;
    loginReq.write(jsonEncode({
      'email': 'siswa@example.com', // guess
      'password': 'password',
    }));
    final loginRes = await loginReq.close();
    final loginBody = await loginRes.transform(utf8.decoder).join();
    print('LOGIN: $loginBody');
    try {
      final data = jsonDecode(loginBody);
      token = data['access_token'];
    } catch (e) {}
  }
  
  if (token != null) {
    final getTutorUrl = Uri.parse('$baseUrl/getTutorById?tutor_id=10');
    final getTutorReq = await client.getUrl(getTutorUrl);
    getTutorReq.headers.add('Authorization', 'Bearer $token');
    getTutorReq.headers.add('Accept', 'application/json');
    final getTutorRes = await getTutorReq.close();
    print('GET TUTOR BY ID: ${await getTutorRes.transform(utf8.decoder).join()}');
    
    final getScheduleUrl = Uri.parse('$baseUrl/schedule/getTutorSchedulesByDay?tutor_id=10&day=kamis');
    final getScheduleReq = await client.getUrl(getScheduleUrl);
    getScheduleReq.headers.add('Authorization', 'Bearer $token');
    getScheduleReq.headers.add('Accept', 'application/json');
    final getScheduleRes = await getScheduleReq.close();
    print('GET SCHEDULE: ${await getScheduleRes.transform(utf8.decoder).join()}');
  }
}
