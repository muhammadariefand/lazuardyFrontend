import 'package:lazuadry_mobile_fe/domain/entities/home_address.dart';

class HomeAddressModel extends HomeAddress {
  HomeAddressModel({
    super.province,
    super.regency,
    super.district,
    super.subdistrict,
  });

  factory HomeAddressModel.fromJson(Map<String, dynamic> json) {
    return HomeAddressModel (
      province: json['province'] as String?,
      regency: json['regency'] as String?,
      district: json['district'] as String?,
      subdistrict: json['subdistrict'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'province': province,
      'regency': regency,
      'district': district,
      'subdistrict': subdistrict,
    };
  }
}