enum RoleEnum {
  student('student', 'Siswa'),
  tutor('tutor', 'Tutor'),
  parent('parent', 'Orang Tua');

  final String label;
  final String display;

  const RoleEnum(this.label, this.display);
}