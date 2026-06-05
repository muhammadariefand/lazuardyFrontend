class RegisterStudentRequest {
  final String email;
  final String password;
  final String name;
  final int classId;
  final String gender;
  final String dateOfBirth;
  final String telephoneNumber;
  final String province;
  final String regency;
  final String district;
  final String subdistrict;

  RegisterStudentRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.classId,
    required this.gender,
    required this.dateOfBirth,
    required this.telephoneNumber,
    required this.province,
    required this.regency,
    required this.district,
    required this.subdistrict,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "name": name,
      "class_id": classId,
      "gender": gender,
      "date_of_birth": dateOfBirth,
      "telephone_number": telephoneNumber,
      "province": province,
      "regency": regency,
      "district": district,
      "subdistrict": subdistrict,
      "google_id": null,
      "facebook_id": null,
    };
  }
}
